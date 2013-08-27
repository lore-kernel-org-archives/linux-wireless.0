Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55971 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3H0QXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 12:23:11 -0400
Received: by mail-oa0-f53.google.com with SMTP id k18so5581223oag.40
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 09:23:10 -0700 (PDT)
Message-ID: <521CD266.5010801@lwfinger.net> (sfid-20130827_182317_323379_F90C1294)
Date: Tue, 27 Aug 2013 11:23:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problems associating to AP with rtl8192cu driver
References: <5217B01D.4000609@ilande.co.uk> <521B9A74.60603@ilande.co.uk>
In-Reply-To: <521B9A74.60603@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2013 01:12 PM, Mark Cave-Ayland wrote:
> On 23/08/13 19:55, Mark Cave-Ayland wrote:
>
>> Can anyone provide any hints to debugging the issue? I've just updated
>> to Linus' latest git master from earlier today and the issue still
>> appears :(
>
> I spent some more time today trying to debug what was happening, and ended up
> setting up a temporary hostapd access point so that I could get logs from both
> the AP and my laptop workstation.
>
> The bug I'm chasing seems to be related to the EAPOL handshake between my laptop
> and the AP. A session with Wireshark shows something like this:
>
> AP -> Laptop : EAPOL 1/4
> Laptop -> AP : EAPOL 2/4
>
> (pause - EAPOL timeout of several seconds)
>
> AP -> Laptop : EAPOL 1/4
> Laptop -> AP : EAPOL 2/4
>
> This pattern is repeated throughout the connection attempts. Comparing
> wpa_supplicant logs from a workstation with an Intel iwlwifi card shows that the
> AP never sends the EAPOL 3/4 packet, suggesting that something in the EAPOL 2/4
> packet was invalid causing the authentication attempt to be dropped.
>
> Interestingly enough if I leave the wpa_supplicant running for a minute or two,
> then sometimes the laptop will authenticate successfully with the AP - this
> suggests that perhaps it may be an initialisation bug of some description?
>
> Can anyone suggest any reasons why the AP never responds with the EAPOL 3/4
> packet as part of the 4-way handshake? To get more information, I set up a fake
> AP using hostapd with logging enabled and recorded the authentication attempts
> on both the AP and the laptop (note that remarkably the laptop managed to
> associate to the AP on the second attempt in this particular session):
>
> AP hostapd log:
> http://www.ilande.co.uk/tmp/hostapd-rtl8192cu-connect.txt
>
> Laptop workstation log:
> http://www.ilande.co.uk/tmp/wpasupplicant-rtl8192cu-connect.txt
>
> Also just to confirm that all testing was done against commit
> 6a7492a4b2e05051a44458d7187023e22d580666 and therefore should contain the WPA
> association fix "rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1)
> networks" from commit 5b8df24e22e0b00b599cb9ae63dbb96e1959be30.

I just retested and this message was posted from what lsusb says is a "Bus 001 
Device 007: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n Wireless 
Adapter [Realtek RTL8188CUS]" connected to an AP using WPA(1).

My kernel is 3.11.0-rc6-wl+ from the wireless-testing tree. I have built 
3.11-rc7-wl+, but not yet rebooted. Before I boot into that kernel, I will build 
and test the mainline kernel, but it should not make a difference as the only 
code differences between wireless-testing and the mainline trees deal with 
cleaning up some sparse endian issues.

What is the make/model of the AP that fails? Is its firmware the latest 
available? Just to confirm, you are running WPA1 encryption.

Do you still have the wireshark file from the failed attempt? If so, could you 
filter out the traffic from APs and stations other than the units trying to make 
the connection, and send me (privately) the trimmed file?

For completeness, I have tested WPA2 with Netgear WNDR3300 and WNDR3400 running 
standard firmware, WPA1 with a Linksys WRT54GL running openWRT Kamikaze fw, and 
WEP with a Linksys WRT54G V5 running standard fw.

Larry

