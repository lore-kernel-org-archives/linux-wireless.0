Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0LFNOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 08:14:47 -0500
Received: by bwz15 with SMTP id 15so10497988bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 05:14:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
Subject: Re: ar9170usb slow / poor performance
Date: Mon, 6 Dec 2010 14:14:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <4CFCA416.1010505@gmail.com>
In-Reply-To: <4CFCA416.1010505@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012061414.27159.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 December 2010 09:51:34 Wade Fitzpatrick wrote:
> I have 2 USB wireless dongles:
>   - Generic Realtek RTL8187 using rtl8187 driver
>   - Netgear WN111v2 [Atheros AR9001-U(2)NG] using ar9170usb driver
> 
> Performance of the Netgear has degraded severely since updating to Arch 
> Linux kernel 2.6.36.1-3 from 2.6.35.4-2, also reported by 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/59911

here's a list of all changes to ar9170usb during 2.6.35-2.6.36:

git log v2.6.35..v2.6.36 --format=oneline drivers/net/wireless/ath/ar9170/ ->
5db5584441c drivers/net/wireless: Restore upper case words in wiphy_<level> messages
a55427e8284 ar9170: add get_survey callback in order to get channel noise
c96c31e499b drivers/net/wireless: Use wiphy_<level>

I don't think any of these changes would cause such problems.

> # iwconfig
Don't use iwconfig. iwconfig and other tools like iwlist, iwspy and
iwevent are obsolete and deprecated.

What you want is: "iw dev wlanX link" instead.
<http://wireless.kernel.org/en/users/Documentation/iw/replace-iwconfig>
<http://wireless.kernel.org/en/users/Documentation/iw>
> wlan0     IEEE 802.11bgn  ESSID:"waddles"
>            Mode:Managed  Frequency:2.412 GHz  Access Point: 00:22:3F:07:42:F3
>            Bit Rate=117 Mb/s   Tx-Power=20 dBm
>            Link Quality=34/70  Signal level=-76 dBm
117 MBits/s, so ar9170usb? must be sending with 802.11n MCS rates. 

> wlan1     IEEE 802.11bg  ESSID:"waddles"
>            Mode:Managed  Frequency:2.412 GHz  Access Point: 00:22:3F:07:42:F3
>            Bit Rate=36 Mb/s   Tx-Power=20 dBm
>            Link Quality=44/70  Signal level=-66 dBm
where as rtl8187 only sticks to b/g rates.

for a fair comparison, I would recommend that both drivers should
stick to b/g. So you could either disable minstrel_ht, or patch
the driver (patch attached... just scroll down).

Or is it the other way round and ar9170usb is wlan1?
> I have also tried using the carl9170 driver (2010_12_02) with 
> compat-wireless and carl9170-fw (1.9.1-1) but I found 'iwconfig' would 
> segfault when it tried to display ath0.
ath0? neither ar9170usb nor carl9170 (in fact no mac80211 driver)
names the interface "ath0". Only the original vendor driver "otus"
did that.

Regards,
	Chr

---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 32bf79e..cb2d1a7 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -145,7 +145,7 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
 
 #define AR9170_HT_CAP							\
 {									\
-	.ht_supported	= true,						\
+	.ht_supported	= false,					\
 	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
 			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
 			  IEEE80211_HT_CAP_SGI_40 |			\
