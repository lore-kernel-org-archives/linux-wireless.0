Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:38889 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753635AbdLPSdv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Dec 2017 13:33:51 -0500
Received: by mail-wr0-f169.google.com with SMTP id o2so10652185wro.5
        for <linux-wireless@vger.kernel.org>; Sat, 16 Dec 2017 10:33:51 -0800 (PST)
Date: Sat, 16 Dec 2017 19:33:47 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20171213152017.GA3554@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain> (sfid-20171216_193359_200151_FB5FBD50)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain> <20171213152017.GA3554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I tested the Archer MR200 device removing the patch as you suggested:
package/kernel/mac80211/patches/600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
... the error still appears, but the driver is still working as of now.
Here - reporting my dmesg
[  819.060392] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.069900] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.079369] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.088823] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.098277] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.107729] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.117174] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.126627] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.136080] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.145533] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.154987] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.164441] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.173890] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.183336] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.192782] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.202200] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.211644] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.221090] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.230537] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.239983] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  819.249430] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2

To cause it, it seems a good technique to use a device as far as possible from the AP, but not enough to disconnect / stop working.
A reauthentication may be required to use the AP again,

Sat Dec 16 17:59:01 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
Sat Dec 16 17:59:01 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 1)
Sat Dec 16 17:59:01 2017 daemon.notice hostapd: wlan0: AP-STA-CONNECTED xx:xx:xx:xx:xx:xx
Sat Dec 16 17:59:01 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.060392] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.069900] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.079369] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.088823] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.098277] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.107729] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.117174] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.126627] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.136080] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.145533] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.154987] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.164441] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.173890] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.183336] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.192782] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.202200] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.211644] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.221090] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.230537] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.239983] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:04:20 2017 kern.err kernel: [  819.249430] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Dec 16 18:11:11 2017 daemon.info hostapd: wlan0: STA x2:x2:x2:x2:x2:x2 IEEE 802.11: authenticated
Sat Dec 16 18:11:11 2017 daemon.info hostapd: wlan0: STA x2:x2:x2:x2:x2:x2 IEEE 802.11: associated (aid 2)
Sat Dec 16 18:11:11 2017 daemon.notice hostapd: wlan0: AP-STA-CONNECTED x2:x2:x2:x2:x2:x2
Sat Dec 16 18:11:11 2017 daemon.info hostapd: wlan0: STA x2:x2:x2:x2:x2:x2 WPA: pairwise key handshake completed (RSN)
Sat Dec 16 18:18:43 2017 daemon.notice hostapd: wlan0: AP-STA-DISCONNECTED x2:x2:x2:x2:x2:x2
Sat Dec 16 18:18:43 2017 daemon.info hostapd: wlan0: STA x2:x2:x2:x2:x2:x2 IEEE 802.11: disassociated due to inactivity
Sat Dec 16 18:18:44 2017 daemon.info hostapd: wlan0: STA x2:x2:x2:x2:x2:x2 IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
Sat Dec 16 18:19:03 2017 daemon.notice hostapd: wlan0: AP-STA-DISCONNECTED xx:xx:xx:xx:xx:xx
Sat Dec 16 18:19:03 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due to inactivity
Sat Dec 16 18:19:04 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
Sat Dec 16 19:16:03 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: authenticated
Sat Dec 16 19:16:03 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: associated (aid 1)
Sat Dec 16 19:16:03 2017 daemon.notice hostapd: wlan0: AP-STA-CONNECTED xx:xx:xx:xx:xx:xx
Sat Dec 16 19:16:03 2017 daemon.info hostapd: wlan0: STA xx:xx:xx:xx:xx:xx WPA: pairwise key handshake completed (RSN)

where the xx:xx... mac is an iPhone SE, the x2:x2... is an Android device.

thank you very much for the help and all.
For the moment I am not sure about the situation still, so I think further testing would be needed. Hoping someone experiencing this problem can come up and give some more hints / tests on different hw.
Thank you to all,
Enrico

On Wed, 13 Dec 2017, Stanislaw Gruszka wrote:

> Date: Wed, 13 Dec 2017 16:20:18
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: Enrico Mioso <mrkiko.rs@gmail.com>
> Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
>     Daniel Golle <daniel@makrotopia.org>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, nbd@nbd.name
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> On Mon, Dec 11, 2017 at 09:51:29PM +0100, Enrico Mioso wrote:
>> Hello guys, and sorry for the big CC list.
>> I would like to point out about a bug who survived for years - at least from 2015 until now, regarding the Ralink driver getting stuck, and in some cases not being able to recover.
>> The problem manifested with an MT7620A chip, and the wireless card inside the WL-330N3G device.
>> The error message is in rt2x00/rt2x00queue.c .
>>
>> This bug was discussed, and a patch proposed, in this thread:
>> https://lists.openwrt.org/pipermail/openwrt-devel/2015-September/thread.html#35778
>>
>> I would like to help if possible - I have the have both an Archer MR200, and the WL330n3G hardware.
>> BTW, the Archer MR200 is a nice MT7610 device, and the problem manifests itself, see:
>> https://forum.openwrt.org/viewtopic.php?id=64293&p=6
>>
>> Any help, hint, anything would be apreciated.
>> thank you to all.
>
> First I would try to remove this patch:
> http://git.lede-project.org/?p=source.git;a=blob;f=package/kernel/mac80211/patches/600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> and see if it makes things better. However I think for the stuck problem
> we need tx status timeout mechanism similar like for rt2800usb.
>
> Attached patch can mitigate "Dropping frame due to full tx queue"
> errors. I did not test it, so it can be totally broken.
>
> Regards
> Stanislaw
>
