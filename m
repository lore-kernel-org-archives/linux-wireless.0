Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38527 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2EZR4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 13:56:06 -0400
Received: by dady13 with SMTP id y13so2513970dad.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 May 2012 10:56:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC04B5A.1070900@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
Date: Sat, 26 May 2012 10:56:05 -0700
Message-ID: <CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com> (sfid-20120526_195611_817704_2EC17434)
Subject: Re: Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 May 2012 20:17, Ben Greear <greearb@candelatech.com> wrote:
> We've been doing some tests using Atheros stations and various APs.  The max
> throughput
> we've seen so far is about 237Mbps (received UDP payload on the stations).
> (Open-Air, AP about 5 feet away, 3x3 MIMO, HT40, 5Ghz, etc).
>
> We are still running lots of different permutations, but I am interested if
> anyone else has any numbers to share (official or otherwise).

FWIW, FreeBSD was getting 270MBit/sec one-way UDP and 150MBit one-way
TCP out of AR9160/AR9280's late last year. I should re-run those tests
again now that I've fixed a bunch of things and see if I've regressed.
Those are 2T2R devices w/ a Routerstation Pro (AR7161) as the hostap.

At that stage I was maxing out the AR7161 CPU quite badly and filling
up all kinds of TX/RX paths, to the point that beacon transmission
stopped being reliable. But I haven't really sat down and run
performance measurements on MIPS so it's quite possible there's some
inefficiencies in FreeBSD that I can work around (to reduce the CPU
overhead, I was happy with the throughput.. :)

Sujith, would you mind testing out ath9k/openwrt on a DB120 and see if
you can get the same results as our internal LSDK builds?

Thanks,


Adrian
