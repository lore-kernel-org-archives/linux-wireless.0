Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbYGaCGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 22:06:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 19:06:19 -0700
Date: Wed, 30 Jul 2008 19:06:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: [PATCH 11/16] ath9k: Remove "OS_" prefixes in macros.
Message-ID: <20080731020617.GJ7625@tesla> (sfid-20080731_040623_463712_984AFFF8)
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com> <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com> <1217467009.3616.9.camel@dv> <43e72e890807301823w3b800ebcwa12317e0a45d0dcb@mail.gmail.com> <1217468689.17029.7.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1217468689.17029.7.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 06:44:49PM -0700, Pavel Roskin wrote:
> On Wed, 2008-07-30 at 18:23 -0700, Luis R. Rodriguez wrote:
> > On Wed, Jul 30, 2008 at 6:16 PM, Pavel Roskin <proski@gnu.org> wrote:
> > > On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
> > >> From: Sujith Manoharan <smanoharan@atheros.com>
> > >>
> > >> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> > >> index 6fa1eb6..c3294c0 100644
> > >> --- a/drivers/net/wireless/ath9k/ath9k.h
> > >> +++ b/drivers/net/wireless/ath9k/ath9k.h
> > >> @@ -622,17 +622,15 @@ struct hal_country_entry {
> > >>
> > >>  #define SM(_v, _f)  (((_v) << _f##_S) & _f)
> > >>  #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
> > >> -#define OS_REG_RMW(_a, _r, _set, _clr)    \
> > >> +#define REG_RMW(_a, _r, _set, _clr)    \
> > >>       REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
> > >
> > > I think these are pretty good candidates for inline functions.  I'm not
> > > sure removing "OS_" is a useful intermediate step.  It's better to keep
> > > such massive changes to the minimum to avoid potential conflicts with
> > > other patches.
> >
> > This was done in response to Johannes comments. This can be moved to
> > inline though.
> 
> It would be really nice.  Explicit return types tend to unmask some
> issues in the calling code, if there are any.
> 
> I don't care if you are going to change the macros/functions themselves
> in many steps, but let's avoid the need to rename all callers again.

Agreed.

  Luis
