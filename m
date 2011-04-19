Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4422 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1DSNqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:46:15 -0400
Message-ID: <4DAD920A.9080500@broadcom.com>
Date: Tue, 19 Apr 2011 15:45:46 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	"gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
 <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
 <1303215002.27432.5.camel@maggie>
In-Reply-To: <1303215002.27432.5.camel@maggie>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys,

Greg, please drop this patch set. Rest of this email is FYI only.

Michael:

> Are you sure? __mips__ is automagically defined by GCC, if compiling
> for MIPS. Maybe it should be converted to some CONFIG_... symbol.
> But removal seems wrong.

You are right. The majority of the removed #ifdef __mips__ code has to 
do with write flushing. To accomplish this, it performs a R_REG after a 
W_REG. I assumed that writeb() and friends guarantee ordering and write 
flushing, but after some reading I learned that this is not the case.

I will rework the code and submit a new patch set.

For some background info: this patch was a reaction on an email from 
John Linville to us. John wrote:

<quote>
I took a quick run through a pull of staging from today.  I made a few
notes, but a lot of them would seem to relate to the utils stuff you
mention above.  One general comment would be that there still seems
to be a lot of MIPS-specific stuff buried in the code, in particular
a lot of "#ifdef __mips__" stuff that if necessary should at least
be hidden inside the W_REG macro.
</quote>

Thanks, Roland.

