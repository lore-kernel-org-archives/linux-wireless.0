Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:4622 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761680Ab0J1UKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 16:10:13 -0400
Message-ID: <4CC9D50F.5070403@gmail.com>
Date: Thu, 28 Oct 2010 21:54:55 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Lee <lee-in-berlin@web.de>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
References: <4CC0D0F6.4080507@web.de> <201010260740.47692.helmut.schaa@googlemail.com> <4CC93148.7090308@web.de> <201010281023.26957.helmut.schaa@googlemail.com> <4CC9C9A4.2020802@web.de>
In-Reply-To: <4CC9C9A4.2020802@web.de>
Content-Type: multipart/mixed;
 boundary="------------010908000305000609090902"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010908000305000609090902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/28/10 21:06, Lee wrote:
> On 28/10/10 10:23, Helmut Schaa wrote:
>> Am Donnerstag 28 Oktober 2010 schrieb Lee:
>>> On 26/10/10 07:40, Helmut Schaa wrote:
>>>> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
>>>>
>>>> Do you see any frames from your specific client?
>>>
>>> Yes. I can see this:
>>> # tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
>> [...]
>>> 10:10:03.013402 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 14 Pad 20 KeyID 0
>>>
>>> However, on wlan0 I don't see anything beyond the EAPOL packets.
>>> Temporarily turning off WPA encryption let me successfully connect to my AP.
>>
>> Aha, could you please try if loading rt73usb with nohwcrypt=1 helps?
>>
>> Helmut
> 
> (argh, brown paper bag)
> 
> I went through the compiled kernels again, and I've screwed up at the last 
> commit while bisecting (Sorry, Helmut!). The first bad kernel is a commit 
> later:
> 
> # bad: [f1aa4c541e98afa8b770a75ccaa8504d0bff44a7] rt2x00: Write the BSSID to register when interface is added
> 
> On the good side, I tested 2.6.36 with nohwcrypt=1, and it works. Yay!

Hmm, the patch itself that seems to cause the badness doesn't look bad.
However, closer inspection shows that the intf->bssid field may be initialized incorrectly.

I may be a long shot, but can you check if the attached patch helps?

---
Gertjan.

--------------010908000305000609090902
Content-Type: text/plain;
 name="rt2x00-bssid-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rt2x00-bssid-fix.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index bc4cc93..f0da7b7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -284,7 +284,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	memcpy(&intf->mac, vif->addr, ETH_ALEN);
 	if (vif->type == NL80211_IFTYPE_AP) {
-		memcpy(&intf->bssid, vif->addr, ETH_ALEN);
+		memcpy(intf->bssid, vif->addr, ETH_ALEN);
 		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
 				      intf->mac, intf->bssid);
 	} else {

--------------010908000305000609090902--
