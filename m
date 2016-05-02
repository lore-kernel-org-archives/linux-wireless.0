Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54089 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbcEBGde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 02:33:34 -0400
Message-ID: <1462170808.5898.2.camel@sipsolutions.net> (sfid-20160502_083337_981735_8ADA7259)
Subject: Re: [PATCH 1/1] iw: Android.mk & version.sh: update for Android
 based compilation
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>,
	Yongqin Liu <yongqin.liu@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Filipe Brandenburger <filbranden@google.com>
Date: Mon, 02 May 2016 08:33:28 +0200
In-Reply-To: <CAGRGNgUzimCmk+2aBDwqcqxnjRUhRni93UZ9Ln88amX84c8u8w@mail.gmail.com> (sfid-20160429_012659_977445_10CE3B7C)
References: <1461850619-15298-1-git-send-email-yongqin.liu@linaro.org>
	 <CAGRGNgUzimCmk+2aBDwqcqxnjRUhRni93UZ9Ln88amX84c8u8w@mail.gmail.com>
	 (sfid-20160429_012659_977445_10CE3B7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-29 at 09:26 +1000, Julian Calaby wrote:

> > +
> > +# Silence some warnings for now. Needs to be fixed upstream.
> > b/26105799
> Comments like this worry me: who is being referred to as "upstream",
> what are these warnings and why has nobody fixed them?
> 

It's funny, because we're upstream (the kernel.org iw repository I
maintain) and they're submitting a Makefile to the same upstream -
saying that "upstream" should fix warnings.

In reality, it's a deluded comment - the warnings from -Wunused-
parameter are entirely useless and cannot be fixed without cluttering
the code with __maybe_unused (or so) since the functions implement
APIs.

This alone is a reason to reject this patch.

If there are legitimate warnings, submit patches first to fix them (and
perhaps add the relevant warning to the real Makefile).

If I then reject those "fixes", don't put such a baselessly accusatory
comment into the Makefile.

johannes
