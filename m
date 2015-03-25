Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbbCYA26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 20:28:58 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au: Update RT_TRACE macro and uses
References: <1427220609.5642.39.camel@perches.com>
	<1427238404.12126.17.camel@perches.com>
Date: Tue, 24 Mar 2015 20:28:56 -0400
In-Reply-To: <1427238404.12126.17.camel@perches.com> (Joe Perches's message of
	"Tue, 24 Mar 2015 16:06:44 -0700")
Message-ID: <wrfjegodj4xj.fsf@redhat.com> (sfid-20150325_012922_656580_924DEA6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> Create an rt_trace function using %pV to reduce overall code size.
> Update the macro uses to remove unnecessary and now harmful parentheses.
>
> Miscellanea around these changes:
>
> o Coalesce formats
> o Realign arguments
> o Remove commented-out RT_TRACE uses
> o Spelling fixes in formats
> o Add missing newlines to formats
> o Remove multiple newlines from formats
> o Neaten formats where noticed
> o Use %pM in one instance
>
> Reduces code size ~20KB
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Mostly done by various scripts&emacs.
> Compiled, untested, no hardware,

This could be further improved by fixing up all the places where the
function name is hard coded into the print statement, instead of using
__func__. In particular as a lot of it is carried over from old code
and has been renamed since.

It's OK with me to do this in a follow-on patch though.

Jes
