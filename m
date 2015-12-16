Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59398 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900AbbLPD3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 22:29:31 -0500
Message-ID: <5670DA9A.4010102@candelatech.com> (sfid-20151216_042934_976896_DCE1A2B3)
Date: Tue, 15 Dec 2015 19:29:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"me@bobcopeland.com >> Bob Copeland" <me@bobcopeland.com>
Subject: question on "mac80211_hwsim: support any address in userspace"
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch below was added to the kernel around 2/24/2015

I am curious mostly about the first change:  I thought the transmitter-addr
relates to the radio device, not the vdev (sta, ap, etc).

But, wouldn't using data from the header break that assumption?


Is there any actual advantage to having more than one address per
hwsim radio?  It seems it complicates things for no particular
reason as far as I can tell?

Thanks,
Ben


mac80211_hwsim: support any address in userspace

     Due to the checks in get_hwsim_data_ref_from_addr, wmediumd
     was only able to use the second mac address (those starting with
     0x42).  This is confusing and needlessly limiting, so allow any
     configured address.

     Signed-off-by: Bob Copeland <me@bobcopeland.com>
     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

-------------------- drivers/net/wireless/mac80211_hwsim.c --------------------
index 4a4c658..e259ee1 100644
@@ -906,8 +906,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
  		goto nla_put_failure;
  	}

-	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
-		    ETH_ALEN, data->addresses[1].addr))
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, hdr->addr2))
  		goto nla_put_failure;

  	/* We get the skb->data */
@@ -2608,7 +2607,7 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)

  	spin_lock_bh(&hwsim_radio_lock);
  	list_for_each_entry(data, &hwsim_radios, list) {
-		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
+		if (mac80211_hwsim_addr_match(data, addr)) {
  			_found = true;
  			break;
  		}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

