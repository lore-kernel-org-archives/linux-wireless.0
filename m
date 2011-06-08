Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4979 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1FHMUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 08:20:48 -0400
Message-ID: <4DEF6914.1070800@broadcom.com> (sfid-20110608_142051_486781_B44C0470)
Date: Wed, 8 Jun 2011 14:20:36 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t
 with struct si_pub
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
 <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com>
 <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
 <4DEB3FF3.8090904@broadcom.com>
 <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
 <4DEC825A.2020404@broadcom.com>
 <BANLkTin1Cv9L+mDDjXSPEPthPPX2uGtaVQ@mail.gmail.com>
In-Reply-To: <BANLkTin1Cv9L+mDDjXSPEPthPPX2uGtaVQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> The reason I was pointing this out was that while foo() doesn't need
> to know what's in struct bar, it will help type safety and general
> code cleanliness to have some declaration of struct bar in the
> headers.

Mostly agree with you. It is cleaner to define all forward declarations 
in one header file.

> If we have a module that exports a set of functions in it's header
> file (say "bar.h") like:
>
> extern struct bar *get_bar();
> extern void foo(struct bar *bar);
>
> the struct bar is part of the API of the module, even if no caller
> ever uses it's internals. Therefore the header file should include the
> line:
>
> struct bar;
>
> so that users of the API don't have to declare it themselves to
> suppress the compiler warnings that would be generated otherwise.

Or the header file should include another header file with this 
declaration.

> My objection was to the struct declaration appearing at the top of
> wl_iw.c, rather than in the header file that defines the functions
> that use it.

Got it.

> In fact, looking a bit further around, it appears that this
> declaration is already in aiutils.h making it's appearance at the top
> of wl_iw.c completely redundant, especially given that the file in
> question appears to not use *any* functions that use the struct, and
> if it does, it should include aiutils.h rather than declaring the
> struct itself - and this isn't introducing extra coupling, this is
> merely including the header that defines the API for the code that
> actually uses this struct.

I just created a patch that removes all forward struct declarations from 
.c files. This patch will be part of a future patch set, I have added a 
'Reported-by: ' line with your name to the commit message.

Thanks, Roland.

