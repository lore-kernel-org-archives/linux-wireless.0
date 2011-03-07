Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57763 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1CGELt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 23:11:49 -0500
Received: by bwz15 with SMTP id 15so3546269bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 20:11:48 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Mar 2011 23:11:48 -0500
Message-ID: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com>
Subject: looking for more details on BCM4329, access to 802.11 header
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	hharte2@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I was really hoping to be able to access 802.11 headers of received
packets on a BCM4329 chip embedded on my HTC Incredible.  However, the
further and further I dug in to the source code for the kernel and
BCM4329 driver, the more and more I became less hopeful.  But, I'm
hoping someone with some more knowledge on this chipset might be able
to help (especially you, Howard!).

The HTC Incredible has the wireless driver loaded as a module, and
builds it straight from the kernel tree:
http://android.git.kernel.org/?p=kernel/msm.git;a=tree;f=drivers/net/wireless/bcm4329;h=01f09252ff9b80379e6db6dbb22af4fcba004982;hb=HEAD

After digging through the driver code, it seemed like stripped 802.11
packets come from the BCM4329 with some custom software header
(SDPCM??).  Once the driver receives a packet, it has been stripped of
the 802.11 header, but contains little data such as the channel it was
received on, and the sequence number.  I was hoping to dig up the
entire 802.11 header, or at least the per-packet RSSI.

Next, I was thinking I could kick the card in to promiscuous mode.
Either by explicitly doing so, or by modifying the RX filter to accept
all frames regardless of BSSID.  However, where this happens in
dhd_linux.c, there is a comment:
 /* Mark below code due to current firmware doesn't support it.
   * The error message may mislead other engineers
   */

So it seems as though the binary broadcom firmware does not allow the
card to be set in to promiscuous mode.  I'd like to still muck with
the RX filter to see if I can basically set it in to promiscuous mode
without explicitly doing so.  I'm going to muck around with this, but
if anyone else has experience with this to tell me to bark up another
tree, please let me know :)

It would be great though, if someone could better explain what the
interaction is between the BCM4329 and the host driver.  Is it at all
possible to receive the raw 802.11 header?  Any per-packet RSSI
information?  It looks like the BCM4329 has an on-chip processor which
is doing all of this processing.

Also, it seems like the defacto Android thing to do is, have the
wireless interface be an Ethernet interface.  All wireless frames are
translated in to Ethernet frames, and then pushed upwards.  I noticed
this with the TI chipset in the Droid.  This really limits the amount
of radio information which is, I suppose good for an embedded device,
but bad for hacking :\

Any feedback would be extremely appreciated :)

Thanks!
George
