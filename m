Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51169 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GTURN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 16:17:13 -0400
Date: Wed, 20 Jul 2011 16:00:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath5k: merge ath5k_hw and ath5k_softc
Message-ID: <20110720200004.GB18231@tuxdriver.com> (sfid-20110720_221716_994840_4EC34DFD)
References: <20110715002155.14332.3527.stgit@mj.roinet.com>
 <CAFtRNNy3SvLXUJ8uaOibGfnynS7gwCOMW2x=cLhfPDf9aNw4vQ@mail.gmail.com>
 <CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
 <4E2733BC.3070309@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E2733BC.3070309@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 20, 2011 at 03:59:56PM -0400, Pavel Roskin wrote:
> On 07/20/2011 06:19 AM, Sedat Dilek wrote:
> 
> >I have tested this patch on top of linux-next (next-20110720) and it fails:
> 
> The patch is for wireless-testing.
> 
> >In file included from
> >/mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/drivers/net/wireless/ath/ath5k/caps.c:24:0:
> >/mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/drivers/net/wireless/ath/ath5k/ath5k.h:1072:24:
> >error: field 'toggleq' has incomplete type
> 
> It looks like ath5.h needs to include linux/interrupt.h, which is
> currently included by base.h.
> 
> linux-next is stricter about the includes than wireless-testing.
> Let's not break linux-next, as someone else will need to fix it.
> 
> I'll send another version of the patch, tested both on
> wireless-testing and linux-next.

I already merged a version that incorporated Sedat's change on top
of your.  If that isn't what you want, please post your change as a
patch on top.

Thanks,

JOhn
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
