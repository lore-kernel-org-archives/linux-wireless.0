Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46441 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0IWE6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 00:58:54 -0400
Message-ID: <4C9ADE7E.5070406@candelatech.com>
Date: Wed, 22 Sep 2010 21:58:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org> <1285097307.12764.11.camel@jlt3.sipsolutions.net> <4C990859.70709@openwrt.org> <4C99135A.3090103@candelatech.com> <4C99348F.2090504@openwrt.org> <4C99870C.20006@candelatech.com> <4C99BEFC.2060209@openwrt.org>
In-Reply-To: <4C99BEFC.2060209@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2010 01:31 AM, Felix Fietkau wrote:
> On 2010-09-22 6:33 AM, Ben Greear wrote:
>> On 09/21/2010 03:41 PM, Felix Fietkau wrote:

>>> As I mentioned in another email: at the time we get the tx status
>>> report, we have to consider the sta pointer stale. It may or may not
>>> still be valid.
>>
>> How about this one.  I think it ensures that the sta will never be stale,
> No, it doesn't. At least not in AP mode.
>
>> since it flushes the tx queue on vif removal.  Minimal testing shows it
>> working, but of course I might be missing something.
> In AP mode, a vif has multiple sta. And draining the queue when a sta
> gets removed is not a good idea.

Ok, here's another try.  It does a lookup each time a tx is completed,
so it's not exactly efficient..

I think it might fail the lookup if NIC manages to change it's MAC
while pkts are in the queue, but at least it mostly works.

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5e7af4..9165ac8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -977,7 +977,11 @@ static void ath9k_process_rssi(struct ath_common *common,
          * at least one sdata of a wiphy on mac80211 but with ath9k virtual
          * wiphy you'd have to iterate over every wiphy and each sdata.
          */
-       sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
+       if (is_multicast_ether_addr(hdr->addr1))
+               sta = ieee80211_find_sta_by_hw(hw, hdr->addr2, NULL);
+       else
+               sta = ieee80211_find_sta_by_hw(hw, hdr->addr2, hdr->addr1);
+
         if (sta) {
                 an = (struct ath_node *) sta->drv_priv;
                 if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 85a7323..6543828 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -329,7 +329,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
         rcu_read_lock();

         /* XXX: use ieee80211_find_sta! */
-       sta = ieee80211_find_sta_by_hw(hw, hdr->addr1);
+       sta = ieee80211_find_sta_by_hw(hw, hdr->addr1, hdr->addr2);
         if (!sta) {
                 rcu_read_unlock();

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12a49f0..1b2840f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2419,7 +2419,8 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
   * ieee80211_find_sta_by_hw - find a station on hardware
   *
   * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @addr: station's address
+ * @addr: remote station's address
+ * @addr2: local address (vif->sdata->dev->dev_addr).  Can be NULL for 'any'.
   *
   * This function must be called under RCU lock and the
   * resulting pointer is only valid under RCU lock as well.
@@ -2434,7 +2435,8 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
   * DO NOT USE THIS FUNCTION.
   */
  struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-                                              const u8 *addr);
+                                              const u8 *addr,
+                                              const u8 *localaddr);

  /**
   * ieee80211_sta_block_awake - block station from waking up
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 44e10a9..1ba56a8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -839,12 +839,18 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
  }

  struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
-                                              const u8 *addr)
+                                              const u8 *addr,
+                                              const u8 *localaddr)
  {
         struct sta_info *sta, *nxt;

-       /* Just return a random station ... first in list ... */
+       /* Just return a random station if localaddr is NULL
+        * ... first in list.
+        */
         for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
+               if (localaddr &&
+                   memcmp(sta->sdata->dev->dev_addr, localaddr, ETH_ALEN) != 0)
+                       continue;
                 if (!sta->uploaded)
                         return NULL;
                 return &sta->sta;


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
