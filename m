Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:51135 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755587AbbCRHbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 03:31:02 -0400
Message-ID: <1426663856.10043.15.camel@perches.com> (sfid-20150318_083115_070042_7E3357B8)
Subject: Re: [PATCH] brcmfmac: cfg80211: use msecs_to_jiffies for time
 conversion
From: Joe Perches <joe@perches.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Daniel Kim <dekim@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Mar 2015 00:30:56 -0700
In-Reply-To: <20150318064439.GA25924@opentech.at>
References: <1426593972-17652-1-git-send-email-hofrat@osadl.org>
	 <1426596159.23897.61.camel@perches.com>
	 <20150318064439.GA25924@opentech.at>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 07:44 +0100, Nicholas Mc Guire wrote:
> On Tue, 17 Mar 2015, Joe Perches wrote:
> > On Tue, 2015-03-17 at 08:06 -0400, Nicholas Mc Guire wrote:
> > > Converting milliseconds to jiffies by "val * HZ / 1000" is technically
> > > OK but msecs_to_jiffies(val) is the cleaner solution and handles all
> > > corner cases correctly. This is a minor API consolidation only and
> > > should make things more readable.

> > These API consolidation changes now always have a function
> > call when the compiler may have previously been able to
> > optimize out the "constant * HZ / 1000" calculation.
> >
> > Perhaps the [um]secs_to_jiffies calls should be indirected
> > with yet another static inline with a __builtin_constant_p()
> > test so that the function calls can again be avoided when
> > possible.
> 
> will give it a try 

OK, thanks.

The tricky bit seems to be the movement of
the Makefile for kernel/time/timeconst.h.

  BC      kernel/time/timeconst.h

as include/linux/time.h would need these
calculated #defines

#define MSEC_TO_HZ_MUL32	U64_C(0x80000000)
#define MSEC_TO_HZ_ADJ32	U64_C(0x0)
#define MSEC_TO_HZ_SHR32	31

and the usec ones too.

That created file would have to be moved from
kernel/time/Makefile to some other location
that could be in the normal include path like
include/linux/timeconst.h so that it can be
used by include/linux/time.h



