Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:1105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbXGaMyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 08:54:46 -0400
Received: by ug-out-1314.google.com with SMTP id j3so72616ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 05:54:45 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 14:58:40 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20070731115446.5717.37617.stgit@localhost> <200707311427.58948.IvDoorn@gmail.com> <46AF2D5C.6090803@warmcat.com>
In-Reply-To: <46AF2D5C.6090803@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311458.40936.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Are there known problems with the monitor mode?  It seems incomplete
> even with one virtual interface, eg

Sounds awfully familiar. :(

> 13:37:00.549494 1.0 Mb/s 2437 MHz (0x0480) 192dB signal Probe Request ()
> [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
> 13:37:00.550243 1.0 Mb/s 2437 MHz (0x0480) 192dB signal Probe Request ()
> [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit]
> 13:37:00.590127 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
> [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
> 13:37:00.692568 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
> [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
> 13:37:00.897401 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
> [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
> 13:37:00.999773 1.0 Mb/s 2437 MHz (0x0480) 216dB signal Beacon (froh)
> [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
> 
> and reports the rate as 1Mbps in all cases.  During this capture I have
> another box doing

At which rate should the other box be sending the frames?

> # while [ 1 ] ; do ls -l / ; done
> 
> over an ssh link which is being carried on another wireless device on
> the same box associated on to channel 6...

Could you enable debugfs and do inside the "rt73usb" folder within the
mac80211 debugfs entry do:

echo 16 > csr_offset
cat csr_value

This will read the TXRX_CSR0 register of rt73usb which controls the filtering
of the frames. That will help determining if the missing frames have been
droppen in the hardware or not.

Ivo
