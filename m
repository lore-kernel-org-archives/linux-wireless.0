Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:48709 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYLTHmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 02:42:17 -0500
Received: by gxk6 with SMTP id 6so1239885gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 23:42:16 -0800 (PST)
Message-ID: <cef1c9520812192342s5a2caf4cm4a0c1662fb1d4bf2@mail.gmail.com> (sfid-20081220_084313_775250_C9FBA21C)
Date: Fri, 19 Dec 2008 23:42:16 -0800
From: "Daniel Wu" <dyqith@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlagn and Intel 5300 card mimo3 poor performance?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are running into some unexpected results in performance tests of an
Intel 5300 abgn against a Linksys wrt310n. Any help would be greatly
appreciated.

Using the debugfs and writing a fixed rate hex into the
rate_scale_table, we tested the throughput (with iperf UDP mode)
between the Intel 5300 card to another wired laptop through the
wrt310n.

As far as we can tell, legacy cck, ofdm and siso performance are fine.
We're running into problems when trying to set up triple streams and
three antennas (mimo3).

We're using these hex rates for mimo3:
0x1C110
0x1C111
0x1C112
0x1C113
0x1C114
0x1C115
0x1C116
0x1C117
For each of the rates, we're getting approximately 160Kbps which is far too low.
These rates also seem to cause a "Invalid HT rate index 236" in  dmesg.

At first we thought the 5300 may not be able to do 3 streams at once,
but that's not true, since the device can receive from the AP at much
higher rates (~64.5Mbps)



Also, in iwl-commands.h, there might be a typo on line 258, instead of
bits "3-0", it should be at least bits "6-0"
