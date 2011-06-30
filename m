Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37826 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1F3BRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 21:17:54 -0400
Received: by gwaa18 with SMTP id a18so683862gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 18:17:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinhc2QAgWTk9tur9Y-m2i3tDhvXOQ@mail.gmail.com>
References: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl>
	<BANLkTinhc2QAgWTk9tur9Y-m2i3tDhvXOQ@mail.gmail.com>
Date: Thu, 30 Jun 2011 02:17:53 +0100
Message-ID: <BANLkTi=3imkrK7Chzb5_-c2GT5omo0Ae=g@mail.gmail.com> (sfid-20110630_031802_499021_70325542)
Subject: Re: [ath9k-devel] STBC functionality details request
From: Fred Matthews <fredmm@hotmail.co.uk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Thanks for replying Adrian,

OK, just for clarity, you are saying for 1-stream STBC NICs
(AR9380/9280), when I enable STBC from hostapd, the driver only
transmits in STBC (transmits multiple copies of data to each antenna)
if it sending at MCSs 0-7 (1 stream rates), due to low signal quality
or via fixing the MCS to those values. For all other MCSs STBC is
disabled.

Does the rate adaptation (minstrel/ath9k) tell the driver to use STBC,
or is this done at automatically at a lower level?

Any other information about STBC would be appreciated.

Cheers

On Thu, Jun 30, 2011 at 1:57 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> I think things are a bit confusing, but here goes.
>
> The earlier NICs only support either RX STBC (pre ar9280?) or TX
> 1-stream STBC (ar9280 or above). Multi-stream STBC isn't in any of the
> AR9xxx NICs. It may be in the AR9287; it may be in the AR9300/AR9400.
> I've not looked.
>
> I bet what you're finding is:
>
> * with STBC enabled, for single stream rates, it's tx'ing using STBC.
> It just sets a bit in the TX descriptor.
> * with STBC enabled, for multi-stream rates, it's not setting the STBC
> TX bit and it's instead sending it as a 2 stream packet w/out STBC.
>
> The AR9280 is not a one stream NIC - it's a two stream TX/RX NIC.
> (Unless you're using the AR9281 - which is an AR9280 1T2R stream
> device.) The AR9285 is a 1x1 stream device. The AR9287 is a 2x2 stream
> device.
>
> HTH,
>
>
> Adrian
>
>> I am using STBC (Space Time Block Coding) 1 stream NICs like the AR9280.I would be very grateful someone can kindly advise on how exactly STBC(transmits multiple copies of a data across each of the antennas) works in ath9k.
>> I ask this because when I enable STBC 1-stream, the driver seems to uses Space division multiplexing (can this be disabled/enabled?), since the rate is over 150Mbps.
>> When is STBC activated ?, ...Does Minstrel/ath9k rate adaptation mechanism find first check if Spatial multiplexing is better, if not uses STBC ?
>> Thank you for your time
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
