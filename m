Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4123 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYGaBov (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:44:51 -0400
Subject: Re: [PATCH 11/16] ath9k: Remove "OS_" prefixes in macros.
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Jouni.Malinen@atheros.com,
	Sujith Manoharan <smanoharan@atheros.com>
In-Reply-To: <43e72e890807301823w3b800ebcwa12317e0a45d0dcb@mail.gmail.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
	 <f716bd4495bedc5987c6fd1283a09843e3c9331e.1217309552.git.lrodriguez@atheros.com>
	 <1217467009.3616.9.camel@dv>
	 <43e72e890807301823w3b800ebcwa12317e0a45d0dcb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 21:44:49 -0400
Message-Id: <1217468689.17029.7.camel@dv> (sfid-20080731_034455_698277_BD58EC60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 18:23 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 30, 2008 at 6:16 PM, Pavel Roskin <proski@gnu.org> wrote:
> > On Mon, 2008-07-28 at 22:47 -0700, lrodriguez@atheros.com wrote:
> >> From: Sujith Manoharan <smanoharan@atheros.com>
> >>
> >> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> >> index 6fa1eb6..c3294c0 100644
> >> --- a/drivers/net/wireless/ath9k/ath9k.h
> >> +++ b/drivers/net/wireless/ath9k/ath9k.h
> >> @@ -622,17 +622,15 @@ struct hal_country_entry {
> >>
> >>  #define SM(_v, _f)  (((_v) << _f##_S) & _f)
> >>  #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
> >> -#define OS_REG_RMW(_a, _r, _set, _clr)    \
> >> +#define REG_RMW(_a, _r, _set, _clr)    \
> >>       REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
> >
> > I think these are pretty good candidates for inline functions.  I'm not
> > sure removing "OS_" is a useful intermediate step.  It's better to keep
> > such massive changes to the minimum to avoid potential conflicts with
> > other patches.
> 
> This was done in response to Johannes comments. This can be moved to
> inline though.

It would be really nice.  Explicit return types tend to unmask some
issues in the calling code, if there are any.

I don't care if you are going to change the macros/functions themselves
in many steps, but let's avoid the need to rename all callers again.

-- 
Regards,
Pavel Roskin
