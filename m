Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:49079 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754094Ab0BQUrF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:47:05 -0500
Message-ID: <536092.79402.qm@web23108.mail.ird.yahoo.com>
Date: Wed, 17 Feb 2010 12:47:00 -0800 (PST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
To: Johannes Berg <johannes@sipsolutions.net>,
	okias <d.okias@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, herton@mandriva.com.br
In-Reply-To: <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 17/2/10, okias <d.okias@gmail.com> wrote:

> You have probably right, but when I
> use my testing program:
> 
> #include <stdio.h>
> main() {
> int a;
> printf("%i\n", a);
> a |= 22;
> printf("%i\n", a);
> }
> 
> Output is:
> 0
> 22
> 
> it look correct to me

It is wrong - you are relying on and depending on the compiler zero'ing uninitialized variables for you - which, depends on which compiler you are using, optimization level, etc, may or may not happen. (some compiler does that, under some conditions/optimizations, but you cannot depend on that).

> 
> 
> 2010/2/17 Johannes Berg <johannes@sipsolutions.net>:
> > On Wed, 2010-02-17 at 19:34 +0100, okias wrote:
> >> I did test on small C program, and "int a" is
> equal to int a = 0; so
> >> it should be fine, but maybe I'm wrong.
> >
> > It's not equal. It will be uninitialised stack garbage
> if you don't
> > initialise it.
> >
> > johannes
> >
> 
> 
> 
> -- 
> Jabber/XMPP: okias@isgeek.info
> SIP VoIP: sip:17474537254@proxy01.sipphone.com
> 


      
