Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64682 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2EGJZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:25:40 -0400
Received: by qcro28 with SMTP id o28so1733469qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 02:25:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-jn+L0oik5aNtz5xukiYn=W7McXp1sB=+SLPHj=Gdk5SBA@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
	<CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
	<CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com>
	<CABF+-6WvgwjkrD6WG8GxcXQ+JM7szugFWZbLN6ssJ8589Q7-BA@mail.gmail.com>
	<CABF+-6U8100oTnpaU=anEYtzkktPLvNqp_bm5M+7Yp_Hajv3+w@mail.gmail.com>
	<CAFED-jn+L0oik5aNtz5xukiYn=W7McXp1sB=+SLPHj=Gdk5SBA@mail.gmail.com>
Date: Mon, 7 May 2012 11:25:39 +0200
Message-ID: <CAFED-j=rzUAZ02w8Zh3D9gX1tkb7LF4MWZbmEZTRBY5fvV4egw@mail.gmail.com> (sfid-20120507_112543_709763_05A313B0)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 5 maja 2012 09:20 u¿ytkownik Janusz Dziedzic
<janusz.dziedzic@gmail.com> napisa³:
> 2012/5/4 Kevin Groeneveld <kgroeneveld@gmail.com>:
>>>> So, you should configure this in cw1200_add_interface() for new
>>>> compat-wireless:
>>>>
>>>>        vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
>>>>                             IEEE80211_VIF_SUPPORTS_CQM_RSSI;
>>
>> I tried adding the above code today and I can now connect in station mode.
>>
>> While connected in station mode I get a lot of the following warnings
>> in the log:
>>
>> ieee80211 phy1: Slowpath: tailroom is not big enough. Req: 8, got: 0.
>>
>> Is that anything to worry about?
>
> Yes we have patch for this in mac80211. I can send you on monday.
> cw1200 firmware required pre-allocated IVs.
> Without that performance will be very poor.
>
> There is similar patch in community code - but seems not fullfill all
> our requirements.

Please check such patch, some modification added to:
mac80211: support adding IV-room in the skb for CCMP keys

diff --git a/drivers/staging/cw1200/sta.c b/drivers/staging/cw1200/sta.c
index db05b84..2011fda 100644
--- a/drivers/staging/cw1200/sta.c
+++ b/drivers/staging/cw1200/sta.c
@@ -701,6 +701,8 @@ int cw1200_set_key(struct ieee80211_hw *dev, enum
set_key_cmd cmd,
 		if (sta)
 			peer_addr = sta->addr;

+		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+
 		switch (key->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 965eca8..0da1806 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -939,7 +939,7 @@ static inline bool ieee80211_vif_is_mesh(struct
ieee80211_vif *vif)
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
- *	for a CCMP key if space should be prepared for the IV, but the IV
+ *	for a CCMP key <why only ccmp?> if space should be prepared for
the IV, but the IV
  *	itself should not be generated. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
  */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0ae23c6..8c9ae77 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -399,8 +399,7 @@ static int ccmp_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)
 	u8 scratch[6 * AES_BLOCK_SIZE];

 	if (info->control.hw_key &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
 		/*
 		 * hwaccel has no need for preallocated room for CCMP
 		 * header or MIC fields


BR
Janusz

>
>>
>> The driver did seem to crash on me once today spewing out a lot of
>> WARNINGs and trace info to the log.  Unfortunately I didn't save the
>> log.  I will try to pay more attention to it if it happens again.
>>
>> I also did a bit more testing in AP mode.  After changing hostapd to
>> 802.11g mode I got much better throughput.  However, I did see quite a
>> few warnings in the log such as the following:
>>
>> [  296.854219] ieee80211 phy2: Missed interrupt?
>
> This is critical and this is firmware issue.
> After that driver can do recovery ...
> So, logs after that are not important much ...
>
>
>> [  297.104219] ieee80211 phy2: Multicast delivery timeout.
>> [  254.194450] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000002
>> [   34.731942] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000002
>> [  462.159614] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000002
>> [  482.560642] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000002
>> [  482.568372] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000002
>> [  482.601447] ieee80211 phy2: Multicast delivery timeout.
>> [  482.736948] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000006
>> [  482.879955] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  483.052676] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000006
>> [  483.570836] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  483.578685] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  483.765740] ieee80211 phy2: Requeue for link_id 1 (try 2). STAs
>> asleep: 0x00000006
>> [  483.773462] ieee80211 phy2: Requeue for link_id 1 (try 2). STAs
>> asleep: 0x00000006
>> [  484.340904] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000006
>> [  484.348626] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  484.356344] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  484.670846] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
>> asleep: 0x00000006
>> [  484.903498] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000006
>> [    2.101774] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000000
>> [    2.109569] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000000
>> [    2.119271] ieee80211 phy2: Requeue for link_id 0 (try 2). STAs
>> asleep: 0x00000000
>> [    2.128483] ieee80211 phy2: Requeue for link_id 0 (try 2). STAs
>> asleep: 0x00000004
>> [    2.137894] ieee80211 phy2: Requeue for link_id 0 (try 3). STAs
>> asleep: 0x00000004
>> [    5.629055] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000004
>> [   81.020541] ieee80211 phy2: Missed interrupt?
>> [   85.050556] ieee80211 phy2: Missed interrupt?
>> [   96.410571] ieee80211 phy2: Missed interrupt?
>> [  100.410560] ieee80211 phy2: Missed interrupt?
>> [  105.700565] ieee80211 phy2: Missed interrupt?
>> [  119.410573] ieee80211 phy2: Missed interrupt?
>> [  140.050548] ieee80211 phy2: Missed interrupt?
>> [  156.993680] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000004
>> [  157.001679] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
>> asleep: 0x00000004
>> [  157.240546] ieee80211 phy2: Multicast delivery timeout.
>> [  167.400528] ieee80211 phy2: Missed interrupt?
>>
>> Should I be worried about these?
>>
> Yes :)
>
>
> --
> Janusz Dziedzic



-- 
Janusz Dziedzic
