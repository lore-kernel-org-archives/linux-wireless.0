Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45792 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1DSNtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:49:32 -0400
Subject: Re: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <4DAD920A.9080500@broadcom.com>
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
	 <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
	 <1303215002.27432.5.camel@maggie>  <4DAD920A.9080500@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 15:49:20 +0200
Message-ID: <1303220960.27432.11.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 15:45 +0200, Roland Vossen wrote: 
> Hello guys,
> 
> Greg, please drop this patch set. Rest of this email is FYI only.
> 
> Michael:
> 
> > Are you sure? __mips__ is automagically defined by GCC, if compiling
> > for MIPS. Maybe it should be converted to some CONFIG_... symbol.
> > But removal seems wrong.
> 
> You are right. The majority of the removed #ifdef __mips__ code has to 
> do with write flushing. To accomplish this, it performs a R_REG after a 
> W_REG. I assumed that writeb() and friends guarantee ordering and write 
> flushing, but after some reading I learned that this is not the case.
> 
> I will rework the code and submit a new patch set.
> 
> For some background info: this patch was a reaction on an email from 
> John Linville to us. John wrote:
> 
> <quote>
> I took a quick run through a pull of staging from today.  I made a few
> notes, but a lot of them would seem to relate to the utils stuff you
> mention above.  One general comment would be that there still seems
> to be a lot of MIPS-specific stuff buried in the code, in particular
> a lot of "#ifdef __mips__" stuff that if necessary should at least
> be hidden inside the W_REG macro.
> </quote>

You should probably create a new macro W_REG_FLUSH or something like
that, which enforces ordering by reading back the register, if required.
That avoids ugly #ifdefs in the code.

-- 
Greetings Michael.

