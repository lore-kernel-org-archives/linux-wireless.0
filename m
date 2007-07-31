Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:46444 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbXGaMi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:38:56 -0400
Message-ID: <46AF2D5C.6090803@warmcat.com>
Date: Tue, 31 Jul 2007 13:38:52 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <200707311412.30340.IvDoorn@gmail.com> <46AF28E2.9050905@warmcat.com> <200707311427.58948.IvDoorn@gmail.com>
In-Reply-To: <200707311427.58948.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> Unfortunately there have been reports about devices with that USB ID
> that contains a rt2500usb chipset. There are a number of duplicate USB ID's
> between rt2500usb and rt73usb.
> Some manufacturers like to release new revisions of their wireless USB stick
> with different chipsets but with the same USB ID.

Oh well.

Are there known problems with the monitor mode?  It seems incomplete
even with one virtual interface, eg

13:37:00.549494 1.0 Mb/s 2437 MHz (0x0480) 192dB signal Probe Request ()
[1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
13:37:00.550243 1.0 Mb/s 2437 MHz (0x0480) 192dB signal Probe Request ()
[1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
13:37:00.590127 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
13:37:00.692568 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
13:37:00.897401 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
13:37:00.999773 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY

and reports the rate as 1Mbps in all cases.  During this capture I have
another box doing

# while [ 1 ] ; do ls -l / ; done

over an ssh link which is being carried on another wireless device on
the same box associated on to channel 6...

-Andy
