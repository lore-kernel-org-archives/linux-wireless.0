Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60523 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbaHHQXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 12:23:13 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so2775250wiw.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 09:23:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chris C <chris.a.cremer@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Carl9170fw loading error
Date: Fri, 08 Aug 2014 18:22:56 +0200
Message-ID: <1956876.Pi2xLkHlKO@blech> (sfid-20140808_182321_963186_611CF05A)
In-Reply-To: <CAMKDnrnZweYxca6UxKhTa9B-kMfFmea2EN=qSypkdA+8mX=n-A@mail.gmail.com>
References: <CAMKDnrkHOsLqXz5p8ZjLRL26N14ZByyM5XQ9b=6a0cB5pPmfqw@mail.gmail.com> <1535534.mOj91phO2K@blech> <CAMKDnrnZweYxca6UxKhTa9B-kMfFmea2EN=qSypkdA+8mX=n-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, August 08, 2014 11:19:32 AM Chris C wrote:
> I am trying to very quickly stop/interrupt the transmission of packets
> then be able to restart the transmission.
> By 'very quickly' I mean faster then the time it takes to transmit a
> packet. So if a packet is being transmitted, the transmission should
> be interrupted before the packet is finished transmitting.
> I have tried setting the AR9170_PHY_REG_ACTIVE register to 0 then back
> to 1. Is there a better way?

I don't know the "ins and outs" of the baseband and mac logic to interrupt
a transmission in progress. But the datasheet mentions that it is possible
to prevent any queue from transmitting (Doesn't say it will interrupt it
though). The register which controls this is located at 0x1c3b40
(AR9170_MAC_REG_QOS_PRIORITY_VIRTUAL_CCA). In order to stop the transmission
of a queue 0, you have to set BIT(15). For queue 1 it's BIT(16) and so on.
To enable the transmission again, clear the bit of the queue.
 
> I am also trying to establish communications between the firmware and
> the driver so that the firmware can output some timing information.
> I have tried passing information through the registers. From the
> driver I use the functions carl9170_read_reg and carl9170_write_reg.
> From the firmware I use the functions get and set.
That's fine.

> The problem is that reading and writing to registers often crashes
> the computer. What's the better way of doing this?
Crashing your PC? Do you have an BUGs, PANIC or WARNING logs to 
trace the culprit? The driver shouldn't crash the computer.
(Note: Check if you can reproduce the crashes in a virtual machine [0]).
 
Regards
Christian

[0] <https://blog.nelhage.com/2013/12/lightweight-linux-kernel-development-with-kvm/>

