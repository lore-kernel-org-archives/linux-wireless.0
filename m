Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36403 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcFNTSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 15:18:40 -0400
Received: by mail-wm0-f49.google.com with SMTP id n184so135175370wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 12:18:39 -0700 (PDT)
Date: Tue, 14 Jun 2016 20:18:15 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: netdev@vger.kernel.org, hannes@stressinduktion.org, nbd@nbd.name,
	linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] add basic register-field manipulation macros
Message-ID: <20160614201815.0e0c384c@jkicinski-Precision-T1700> (sfid-20160614_211905_714797_8780C126)
In-Reply-To: <576052A7.2030503@broadcom.com>
References: <1465904660-22242-1-git-send-email-jakub.kicinski@netronome.com>
	<1465904660-22242-2-git-send-email-jakub.kicinski@netronome.com>
	<576052A7.2030503@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 14 Jun 2016 20:53:28 +0200, Arend van Spriel wrote:
> On 14-06-16 13:44, Jakub Kicinski wrote:
> > +#ifndef _LINUX_BITFIELD_H
> > +#define _LINUX_BITFIELD_H
> > +
> > +#include <asm/types.h>
> > +#include <linux/bug.h>
> > +#include <linux/log2.h>
> > +
> > +#define _bf_shf(x) (__builtin_ffsll(x) - 1)
> > +
> > +#define _BF_FIELD_CHECK(_mask, _val)					\
> > +	({								\
> > +		const u64 hi = (_mask) + (1ULL << _bf_shf(_mask));	\
> > +									\
> > +		BUILD_BUG_ON(!(_mask) || (hi && !is_power_of_2_u64(hi))); \
> > +		BUILD_BUG_ON(__builtin_constant_p(_val) ?		\
> > +			     ~((_mask) >> _bf_shf(_mask)) & (_val) :	\
> > +			     0);					\
> > +	})  
> 
> I am sceptic whether it is useful to have 64-bit used here and there is
> a price to pay on (many) 32-bit architectures for using 64-bit
> operations. Maybe it is not an issue because it is inside BUILD_BUG_ON()
> macro.

It's a trade-off between having a separate set of macros for 32-bit
machines and risking someone potentially loosing cycles when using the
macros in a non-standard way.  Note that all 64 bit operations are
performed on the mask which I expect to be compile time constant.

> > +#define FIELD_PUT(_mask, _val)					\
> > +	({							\
> > +		_BF_FIELD_CHECK(_mask, _val);			\
> > +		((u32)(_val) << _bf_shf(_mask)) & (_mask);	\
> > +	})
> > +
> > +#define FIELD_GET(_mask, _val)					\
> > +	({							\
> > +		_BF_FIELD_CHECK(_mask, 0);			\
> > +		(u32)(((_val) & (_mask)) >> _bf_shf(_mask));	\
> > +	})
> > +
> > +#define FIELD_PUT64(_mask, _val)				\
> > +	({							\
> > +		_BF_FIELD_CHECK(_mask, _val);			\
> > +		((u64)(_val) << _bf_shf(_mask)) & (_mask);	\
> > +	})
> > +
> > +#define FIELD_GET64(_mask, _val)				\
> > +	({							\
> > +		_BF_FIELD_CHECK(_mask, 0);			\
> > +		(u64)(((_val) & (_mask)) >> _bf_shf(_mask));	\
> > +	})  
> 
> Is there really hardware out there that exposes 64-bit wide hardware
> registers?

I need this for encoding 64-bit wide RISC instructions [1] to be honest.

[1] http://thread.gmane.org/gmane.linux.network/414538
