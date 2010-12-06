Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55537 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0LFPPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 10:15:38 -0500
Received: by pwj3 with SMTP id 3so1902715pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 07:15:38 -0800 (PST)
Message-ID: <4CFCFE15.1050203@gmail.com>
Date: Tue, 07 Dec 2010 02:15:33 +1100
From: Wade Fitzpatrick <wade.fitzpatrick@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170usb slow / poor performance
References: <4CFCA416.1010505@gmail.com> <201012061414.27159.chunkeey@googlemail.com>
In-Reply-To: <201012061414.27159.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the response, Christian. Here is what I am seeing now, using 
ar9170usb from compat-wireless (2010_12_02):


usb 2-5: new high speed USB device using ehci_hcd and address 5
usb 2-5: reset high speed USB device using ehci_hcd and address 5
usbcore: registered new interface driver ar9170usb
arusb_lnx: module is from the staging directory, the quality is unknown, 
you have been warned.
arusb - version 0.0.0.999
usbcore: registered new interface driver Otus
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
Registered led device: ar9170-phy1::tx
Registered led device: ar9170-phy1::assoc
usb 2-5: Atheros AR9170 is registered as 'phy1'


# iw dev wlan0 link
Connected to 00:22:3f:07:42:f3 (on wlan0)
         SSID: waddles
         freq: 2412
         RX: 2627575 bytes (16028 packets)
         TX: 127342 bytes (600 packets)
         signal: -62 dBm
         tx bitrate: 54.0 MBit/s
# iw dev wlan1 link
Connected to 00:22:3f:07:42:f3 (on wlan1)
         SSID: waddles
         freq: 2412
         RX: 6208 bytes (43 packets)
         TX: 522 bytes (5 packets)
         signal: -61 dBm
         tx bitrate: 6.5 MBit/s MCS 0
# iw event -f
wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason 2: 
Previous authentication no longer valid [frame: c0 00 40 01 00 22 3f 8d 
7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
wlan1 (phy #1): disconnected (by AP) reason: 2: Previous authentication 
no longer valid
wlan1 (phy #1): scan started
wlan1 (phy #1): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 
2452 2457 2462, ""
wlan1 (phy #1): auth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0: 
Successful [frame: b0 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00 22 
3f 07 42 f3 00 00 00 00 02 00 00 00]
wlan1: new station 00:22:3f:07:42:f3
wlan1 (phy #1): assoc 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0: 
Successful [frame: 10 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00 22 
3f 07 42 f3 10 00 31 04 00 00 03 c0 01 08 82 84 8b 0c 12 96 18 24 32 04 
30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 
5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 
00 00 00 00 00 dd 1e 00 90 4c 33 4c 10 1b ff ff 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4c 10 1b ff ff 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 
00 1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 01 
00 1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00]
wlan1 (phy #1): connected to 00:22:3f:07:42:f3
wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason 2: 
Previous authentication no longer valid [frame: c0 00 40 01 00 22 3f 8d 
7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
wlan1 (phy #1): disconnected (by AP) reason: 2: Previous authentication 
no longer valid
wlan1 (phy #1): scan started
wlan1 (phy #1): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 
2452 2457 2462, ""
wlan1 (phy #1): auth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0: 
Successful [frame: b0 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00 22 
3f 07 42 f3 00 00 00 00 02 00 00 00]
wlan1: new station 00:22:3f:07:42:f3
wlan1 (phy #1): assoc 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 status: 0: 
Successful [frame: 10 00 40 01 00 22 3f 8d 7b 05 00 22 3f 07 42 f3 00 22 
3f 07 42 f3 10 00 31 04 00 00 03 c0 01 08 82 84 8b 0c 12 96 18 24 32 04 
30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 
5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 
00 00 00 00 00 dd 1e 00 90 4c 33 4c 10 1b ff ff 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4c 10 1b ff ff 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 01 
00 1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 01 
00 1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00]
wlan1 (phy #1): connected to 00:22:3f:07:42:f3
wlan1 (phy #1): deauth 00:22:3f:07:42:f3 -> 00:22:3f:8d:7b:05 reason 2: 
Previous authentication no longer valid [frame: c0 00 40 01 00 22 3f 8d 
7b 05 00 22 3f 07 42 f3 00 22 3f 07 42 f3 70 00 02 00]
wlan1 (phy #1): disconnected (by AP) reason: 2: Previous authentication 
no longer valid

The wlan1 link is unusable. If I create a host route and ping the modem 
over wlan1, all I get is 'Destination Host Unreachable' messages.

Note that wlan0 (the RTL8187) also has updated drivers but is stable 
throughout this.

Any more suggestions?

Regards,
Wade.

On 07/12/10 00:14, Christian Lamparter wrote:
> On Monday 06 December 2010 09:51:34 Wade Fitzpatrick wrote:
>> I have 2 USB wireless dongles:
>>    - Generic Realtek RTL8187 using rtl8187 driver
>>    - Netgear WN111v2 [Atheros AR9001-U(2)NG] using ar9170usb driver
>>
>> Performance of the Netgear has degraded severely since updating to Arch
>> Linux kernel 2.6.36.1-3 from 2.6.35.4-2, also reported by
>> http://article.gmane.org/gmane.linux.kernel.wireless.general/59911
> here's a list of all changes to ar9170usb during 2.6.35-2.6.36:
>
> git log v2.6.35..v2.6.36 --format=oneline drivers/net/wireless/ath/ar9170/ ->
> 5db5584441c drivers/net/wireless: Restore upper case words in wiphy_<level>  messages
> a55427e8284 ar9170: add get_survey callback in order to get channel noise
> c96c31e499b drivers/net/wireless: Use wiphy_<level>
>
> I don't think any of these changes would cause such problems.
>
>> # iwconfig
> Don't use iwconfig. iwconfig and other tools like iwlist, iwspy and
> iwevent are obsolete and deprecated.
>
> What you want is: "iw dev wlanX link" instead.
> <http://wireless.kernel.org/en/users/Documentation/iw/replace-iwconfig>
> <http://wireless.kernel.org/en/users/Documentation/iw>
>> wlan0     IEEE 802.11bgn  ESSID:"waddles"
>>             Mode:Managed  Frequency:2.412 GHz  Access Point: 00:22:3F:07:42:F3
>>             Bit Rate=117 Mb/s   Tx-Power=20 dBm
>>             Link Quality=34/70  Signal level=-76 dBm
> 117 MBits/s, so ar9170usb? must be sending with 802.11n MCS rates.
>
>> wlan1     IEEE 802.11bg  ESSID:"waddles"
>>             Mode:Managed  Frequency:2.412 GHz  Access Point: 00:22:3F:07:42:F3
>>             Bit Rate=36 Mb/s   Tx-Power=20 dBm
>>             Link Quality=44/70  Signal level=-66 dBm
> where as rtl8187 only sticks to b/g rates.
>
> for a fair comparison, I would recommend that both drivers should
> stick to b/g. So you could either disable minstrel_ht, or patch
> the driver (patch attached... just scroll down).
>
> Or is it the other way round and ar9170usb is wlan1?
>> I have also tried using the carl9170 driver (2010_12_02) with
>> compat-wireless and carl9170-fw (1.9.1-1) but I found 'iwconfig' would
>> segfault when it tried to display ath0.
> ath0? neither ar9170usb nor carl9170 (in fact no mac80211 driver)
> names the interface "ath0". Only the original vendor driver "otus"
> did that.
>
> Regards,
> 	Chr
>
> ---
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 32bf79e..cb2d1a7 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -145,7 +145,7 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
>
>   #define AR9170_HT_CAP							\
>   {									\
> -	.ht_supported	= true,						\
> +	.ht_supported	= false,					\
>   	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
>   			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
>   			  IEEE80211_HT_CAP_SGI_40 |			\
