Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46820 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab1DZPAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 11:00:11 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QEjkD-0001t0-Ub
	for linux-wireless@vger.kernel.org; Tue, 26 Apr 2011 17:00:05 +0200
Received: from brent.tribalogic.net ([78.86.109.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 17:00:05 +0200
Received: from gmane by brent.tribalogic.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 17:00:05 +0200
To: linux-wireless@vger.kernel.org
From: Colin Guthrie <gmane@colin.guthr.ie>
Subject: [Regression] Problem with rfkill on 2.6.38
Date: Tue, 26 Apr 2011 15:00:38 +0100
Message-ID: <ip6j66$o5f$1@dough.gmane.org> (sfid-20110426_170016_050429_A6E2C01A)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

RFKILL used to work fine on 2.6.37 for me but I have a regression on .38.

wifi works fine generally, but after cycling RFKILL I have to reload the
various modules before it works again.

I can turn the machine on with wireless (+bluetooth) enabled and if I
hit the rfkill switch (Fn+F2 on my machine) both wifi and bt turn off as
they should.

If I turn it back on again however, both of the lights turn on briefly
but then the wifi one goes out and bt follows shortly thereafter. The
only way I can find to get wifi back is to reboot or:

[root@jimmy ~]# rmmod btusb
[root@jimmy ~]# rmmod bluetooth
[root@jimmy ~]# rmmod dell_laptop
[root@jimmy ~]# rmmod iwlagn
[root@jimmy ~]# rmmod iwlcore
[root@jimmy ~]# rmmod mac80211
[root@jimmy ~]# rmmod cfg80211
[root@jimmy ~]# rmmod rfkill
[root@jimmy ~]# lsmod | grep rfk
<press button to enable>
[root@jimmy ~]# modprobe iwlagn


The dmesg is below (it's short enough to just paste in-line). What
appears to happen is that when re-enabling it, it will automatically
re-kill it again.

On and working -> Turn off:

iwlagn 0000:0b:00.0: RF_KILL bit toggled to disable radio.
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_QOS_PARAM: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Error setting new RXON (-5)
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON_ASSOC: enqueue_hcmd failed: -5
wlan0: deauthenticating from 00:24:01:c5:4a:16 by local choice (reason=3)
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_REMOVE_STA: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Error removing station 00:24:01:c5:4a:16
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON_ASSOC: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Error setting new RXON (-5)
cfg80211: Calling CRDA to update world regulatory domain
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Error setting new RXON (-5)
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 1
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 3
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 4
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 6
[0xa5a5a5a2]
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: GB
cfg80211: Regulatory domain changed to country: GB
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
usb 4-2: USB disconnect, address 3



Turn back on:

iwlagn 0000:0b:00.0: RF_KILL bit toggled to enable radio.
usb 4-2: new full speed USB device using uhci_hcd and address 4
usb 4-2: New USB device found, idVendor=413c, idProduct=8126
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: BCM2045
usb 4-2: Manufacturer: Broadcom Corp
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwlagn 0000:0b:00.0: RF_KILL bit toggled to disable radio.
<------------Problem here?
iwlagn 0000:0b:00.0: Not sending command - RF KILL
iwlagn 0000:0b:00.0: Error sending REPLY_RXON: enqueue_hcmd failed: -5
iwlagn 0000:0b:00.0: Error setting new RXON (-5)
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 1
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 3
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 4
[0xa5a5a5a2]
iwlagn 0000:0b:00.0: Failing on timeout while stopping DMA channel 6
[0xa5a5a5a2]
usb 4-2: USB disconnect, address 4



FWIW, I already mentioned this problem here:
https://www.mageia.org/pipermail/mageia-dev/20110421/004124.html

Another user using the same kernel with the same hardware cannot
reproduce, so not quite sure what's causing the issue.

iwlagn          : Intel Corporation|PRO/Wireless 4965 AG or AGN [Kedron]
Network Connection [NETWORK_OTHER] (vendor:8086 device:4229 subv:8086
subd:1101) (rev: 61)




I've been looking through the various commits that could come into play
(although I am sure there are others):

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=3dd823e6b86407aed1a025041d8f1df77e43a9c8

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=554d1d027b19265c4aa3f718b3126d2b86e09a08

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=commitdiff;h=6cd0b1cb872b3bf9fc5de4536404206ab74bafdd


What is odd about the 3dd8 commit is that there is code that says:

        if (test_bit(STATUS_INT_ENABLED, &priv->status))
                iwl_enable_interrupts(priv);

I presume test_bit returns "true" if the bit is set? If so, then the
call, is a little strange as iwl_enable_interrupts sets the bit again.

So it's only enabled if it's already set? Perhaps test_bit returns 0
when it's already set?

172 static inline void iwl_enable_interrupts(struct iwl_priv *priv)
173 {
174         IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
175         set_bit(STATUS_INT_ENABLED, &priv->status);
176         iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
177 }


But I'm no kernel hacker, so all this could be rubbish.


Cheers in advance for any insights!

Col

-- 

Colin Guthrie
gmane(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
  Mageia Contributor [http://www.mageia.org/]
  PulseAudio Hacker [http://www.pulseaudio.org/]
  Trac Hacker [http://trac.edgewall.org/]

