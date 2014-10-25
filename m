Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61001 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaJYSa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 14:30:28 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so1466542wiw.8
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 11:30:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544BC1B5.1040107@mailservices.uwaterloo.ca>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
	<544AB9B8.9050407@mailservices.uwaterloo.ca>
	<CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>
	<544BC1B5.1040107@mailservices.uwaterloo.ca>
Date: Sat, 25 Oct 2014 11:30:26 -0700
Message-ID: <CAJ-Vmo=ceFvBDxL=HYSVmAMfEk0yxD_-a4MP3WjcvPAaupxPPw@mail.gmail.com> (sfid-20141025_203031_633277_DB25FBE0)
Subject: Re: strange MPDU loss pattern
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 October 2014 08:28, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Hi Adrian,
>
> We have a high end spectrum analyzer. So we are sure there is no background
> interference
> We run our experiments in the 5 GHZ spectrum. The channel conditions can
> still vary due to
> the movement of the people in the vicinity of the experiment setup. We
> select a rate that
> experiences at least 20% error on average. Since if the error is 100% or 0%
> it's not interesting
> for us.
>
> My point is if the channel conditions change the distribution of failed
> packets should be uniform.
> The first and second  half of the packets have the same chance to be
> received successfully.

Here's a little story.

My first wifi contract had me spend months trying to figure out why an
AP was losing its mind. It'd get stuck in a "stuck beacon" loop and
only a hard powercycle of /all/ of the access points in an area would
clear it.

It turned out that the PCB design had some non-grounded /
non-populated tracks that just "happened" to form a 2GHz resonator.
Once we grounded those tracks, the APs started behaving themselves.

The company in question spent months with high end spectrum analysis
kit in the lab (where it never happened) and underground (where it did
happen.) It's only after they stuck the spectrum analyser probe
_inside the access point_ right up close to the NIC did they see it.

Here's the spectrum analyser traces. You can see the peak.

http://www.creative.net.au/ath/

So, weirder crap has happened.

Which NICs and which MCS rates are you using?



-adrian
