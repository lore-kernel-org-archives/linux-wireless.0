Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46861 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaAYVx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 16:53:26 -0500
Received: by mail-ob0-f174.google.com with SMTP id uy5so5011040obc.5
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 13:53:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADzE2xw0vpeOXxVLdvnfnX57+gRnthrrSnNy=S0HVhH19YS7bQ@mail.gmail.com>
References: <CADzE2xw0vpeOXxVLdvnfnX57+gRnthrrSnNy=S0HVhH19YS7bQ@mail.gmail.com>
Date: Sat, 25 Jan 2014 22:53:25 +0100
Message-ID: <CACna6ryE1At0K9TPddN6T-ySPPK+RwCsMO60yUd_RAgQDdpY8w@mail.gmail.com> (sfid-20140125_225329_797779_63C08375)
Subject: Re: I'm not sure which one of you to send this to, but I do have a
 bug to report.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Wyatt Ward <wyattfward@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/25 Wyatt Ward <wyattfward@gmail.com>:
> The problem is that both  SSB  and BCMA are loading to support the b43
>  module, where I only want SSB to load. I had this issue in 3.11, and
> my custom build of 3.13 worked, but I don't see any changes to b43 or
> BCMA that would effect this. I think that it was my tweaking of the
> compile options for BCMA fixed this, but in any case
>
> I believe that the SSB and BCMA modules are  interfering with each
> other, killing my network speed seemingly at random.

Loading b43 (when compiled with BCMA support) will cause loading both:
ssb and bcma. That's true, this is caused by symbols b43 uses. This is
expected.

Now look at drivers/bcma/host_pci.c and try to find a reference to
0x4312 (since your card it 14e4:4312). Or try to find a sign of "bcma"
in dmesg.

bcma does not try to touch 14e4:4312 in any way. It gets loaded but
does nothing.

There must be something else in your builds affecting performance. If
you want to compare 2 kernels, remember to do cold boots. Some things
in (WiFi) hardware configuration may survive reboot.
