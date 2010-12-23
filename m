Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47550 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0LWBzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 20:55:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 17:55:33 -0800
Date: Thu, 23 Dec 2010 07:25:42 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH v3 1/2] ath9k_hw: Fix incorrect macversion and macrev
 checks
Message-ID: <20101223015542.GA4215@senthil-lnx.users.atheros.com>
References: <1293032660-3627-1-git-send-email-senthilkumar@atheros.com>
 <AANLkTikGgSbAY1FRHNOoVmgVk3BKdvBtY+ir9y5BywW0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTikGgSbAY1FRHNOoVmgVk3BKdvBtY+ir9y5BywW0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 09:22:06PM +0530, Luis R. Rodriguez wrote:
> On Wed, Dec 22, 2010 at 10:44 AM, Senthil Balasubramanian
> <senthilkumar@atheros.com> wrote:
> > There are few places where we are checking for macversion and revsions
> > before RTC is powered ON. However we are reading the macversion and
> > revisions only after RTC is powered ON and so both macversion and
> > revisions are actully zero and this leads to incorrect srev checks
> >
> > Incorrect srev checks can cause registers to be configured wrongly and can
> > cause unexpected behavior. Fixing this seems to address the ASPM issue that
> > we have observed. The laptop becomes very slow and hangs mostly with ASPM L1
> > enabled without this fix.
> 
> On what chipset? Or did we see this on one chipset and suspect it can
> affect others?
We have noticed on Merlin and it is obviously incorrect for other chipsets
also :-(. Please feel free to rephrase/rework on this patch if you think
something is still lacking/missing...
> 
>  Luis
