Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45855 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0HGGaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 02:30:22 -0400
Received: by wyb39 with SMTP id 39so8482413wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 23:29:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5C9252.7040007@bu3sch.de>
References: <4C5C9252.7040007@bu3sch.de>
Date: Sat, 7 Aug 2010 08:29:49 +0200
Message-ID: <AANLkTikotSiDU1ZGetwB8=XJVZrn-HQYDHGm8KT1dVPF@mail.gmail.com>
Subject: Re: ssb: 2.6.34.1 -> 2.6.34.2 regression
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: stable@kernel.org, Christoph Fritz <chf.fritz@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/7 Michael Büsch <mb@bu3sch.de>:
> The SPROM changes applied to SSB in 2.6.34.2 completely broke SPROM
> extraction. This leads to broken wireless for my BCM4306 card.
> All other BCM43xx and BCM44xx most likely are affected, too.
> Symptoms should be wrong MAC addresses and broken transmission (for 43xx).
>
> The patch changed the SPEX() macro and removed the offset subtraction,
> but did not remove the actual 0x1000 offset from the SPROM defines.
> This results in random memory poking rather than proper SPROM data
> extraction.
>
> I applied the following to my kernel to get it working again. However
> this is not a proper fix. I suggest that the -stable SSB patch
> is dropped and mainline patches being applied. They seem to
> be correct (However I did not test mainline, yet).

The original patch didn't simply drop subtraction of offset, it also
modified defines in .h:
http://marc.info/?l=linux-wireless&m=127006884129062&w=4

It's Larry combined patch that you see in .34.2 and it indeed lacks
changes in defines. We already explained that situation, Greg will
revert it and apply correct patches instead.

-- 
Rafał
