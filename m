Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:34996 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXH1Vup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 17:50:45 -0400
Received: by wr-out-0506.google.com with SMTP id 36so1414679wra
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 14:50:44 -0700 (PDT)
Message-ID: <43e72e890708281450p14b9606el3575e2aceffb6fb@mail.gmail.com>
Date: Tue, 28 Aug 2007 17:50:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <46D45F9B.2000000@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2713029743177393055@pripojeni.net>
	 <20070828171034.GB29343@infradead.org>
	 <1188322410.7837.113.camel@johannes.berg>
	 <46D45F9B.2000000@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/28/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Johannes Berg wrote:
> > On Tue, 2007-08-28 at 18:10 +0100, Christoph Hellwig wrote:
> >> On Tue, Aug 28, 2007 at 11:58:52AM -0400, Jiri Slaby wrote:
> >>> -ath5k-objs         = ath5k_base.o ath5k_hw.o ath5k_regdom.o
> >>> +ath5k-objs         = ath5k_base.o ath5k_hw.o ath5k_regdom.o \
> >>> +                     ath5k_hw_phy.o ath5k_hw_inivals.o
> >> And while I'm at nitpicking :)
> >>
> >> ath5k_hw_phy.o should probably be ath5k_phy.o by conventions used by
> >> most drivers and ath5k_hw_inivals.o mights aswell be something like
> >> ath5k_init.o
> >
> > While we're at names... I personally much prefer a new directory ath5k
> > and then ath5k/hw.c etc. but it seems I'm pretty alone in that. But here
> > we already have at least four files now.
>
> I agree with you. If a wireless driver takes more than one .c and one .h file, it belongs in its own
> directory, and the file names stripped of any driver prefix. Not only are the file names simpler,
> but Makefile and Kconfig in wireless benefits.

NACK, I don't agree with this patch. The ath5k_regdom.* files will be
gone soon anyway and don't see the reason to split the files even
more. Now iwlwifi... -- that could is own directory IMHO :)

  Luis
