Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38537 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1F3A5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 20:57:36 -0400
Received: by gwaa18 with SMTP id a18so679396gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 17:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl>
References: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl>
Date: Thu, 30 Jun 2011 08:57:35 +0800
Message-ID: <BANLkTinhc2QAgWTk9tur9Y-m2i3tDhvXOQ@mail.gmail.com> (sfid-20110630_025744_670002_680611CA)
Subject: Re: [ath9k-devel] STBC functionality details request
From: Adrian Chadd <adrian@freebsd.org>
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think things are a bit confusing, but here goes.

The earlier NICs only support either RX STBC (pre ar9280?) or TX
1-stream STBC (ar9280 or above). Multi-stream STBC isn't in any of the
AR9xxx NICs. It may be in the AR9287; it may be in the AR9300/AR9400.
I've not looked.

I bet what you're finding is:

* with STBC enabled, for single stream rates, it's tx'ing using STBC.
It just sets a bit in the TX descriptor.
* with STBC enabled, for multi-stream rates, it's not setting the STBC
TX bit and it's instead sending it as a 2 stream packet w/out STBC.

The AR9280 is not a one stream NIC - it's a two stream TX/RX NIC.
(Unless you're using the AR9281 - which is an AR9280 1T2R stream
device.) The AR9285 is a 1x1 stream device. The AR9287 is a 2x2 stream
device.

HTH,


Adrian

> I am using STBC (Space Time Block Coding) 1 stream NICs like the AR9280.I would be very grateful someone can kindly advise on how exactly STBC(transmits multiple copies of a data across each of the antennas) works in ath9k.
> I ask this because when I enable STBC 1-stream, the driver seems to uses Space division multiplexing (can this be disabled/enabled?), since the rate is over 150Mbps.
> When is STBC activated ?, ...Does Minstrel/ath9k rate adaptation mechanism find first check if Spatial multiplexing is better, if not uses STBC ?
> Thank you for your time
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
