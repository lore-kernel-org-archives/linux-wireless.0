Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46349 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0HKQ4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 12:56:17 -0400
Received: by eya25 with SMTP id 25so185454eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Aug 2010 09:56:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Aug 2010 09:56:15 -0700
Message-ID: <AANLkTikq5T_Ko0gpiKRc2xpOOVJz5bHffm_2Ps5YsT82@mail.gmail.com>
Subject: loss in ath9k not reported?
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to track down the cause of loss in the ath9k driver, and
the loss rates I see at higher layers (e.g., an iperf throughput
test), and what kind of losses are reported in the driver is
inconsistent.

For example, I enable debugging and I see over 1000 packet losses in
iperf and through another low level sequence numbering mechanism I
inserted in the driver, but when checking
"/sys/kernel/debug/ath9k/phy1/recv" ... i see that it only reports  32
CRC errors, and 1 PHY error.

So then I decided to try adding kernel debug statements in
net/mac80211/rx.c in should_drop_frame() and and any check on the
rx_status for CRC error or PHY error.  This is done in the code via
if(status->flag & RX_FLAG_FAILED_FCS_CRC) or FX_FLAG_FAILED_PLCP_CRC.
However, never do I see any pieces of this code triggered, despite
there being loss on the wireless link.

Then I checked a little higher up in the ath9k driver:
drivers//net/wireless/ath/ath9k/recv.c.  In ath9k_rx_accept() I check
rx_stats->rs_status against ATH9K_RXERR_CRC and ATH9K_RXERR_PHY.
Again, neither seem to be set in correlation with losses I see on the
wireless link.  But for there to be an error of this type, the MAC
layer must push up packets with these errors, from what I understand.
If the MAC is doing these checks and dropping, they will not get here.
This is why I started checking for the errors at the MAC.

I know that there are losses on the wireless link, as I am inserting
sequence numbers at driver level and am noticing missing ACKs at the
transmitter.

Is there a critical piece of code I am not finding which is removing
these frames in error before I check them?

Thanks for any help, and please CC me if you respond to the list since
I am not subscribed.  I would appreciate it.

- George
