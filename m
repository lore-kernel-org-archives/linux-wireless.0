Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab2HJDOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 23:14:24 -0400
Date: Thu, 9 Aug 2012 23:13:23 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [Lf_driver_backport] [PATCH v2] compat: support RHEL6.3 as a
 build target
Message-ID: <20120810031323.GE2384@quad.redhat.com> (sfid-20120810_051428_390453_340BFA13)
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
 <2121451356.93690.1344518764022.JavaMail.root@neratec.com>
 <CAB=NE6UNz2oXvCu3NpNVqQLg4pSsL5L-Dw==KGkqxS0CxQfjFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6UNz2oXvCu3NpNVqQLg4pSsL5L-Dw==KGkqxS0CxQfjFg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2012 at 06:27:25PM -0700, Luis R. Rodriguez wrote:
> On Thu, Aug 9, 2012 at 6:26 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> > @@ -101,7 +101,7 @@ struct pm_qos_request_list {
> >  /* mask no_printk as RHEL6 backports this */
> >  #define no_printk(...) compat_no_printk(...)
> >  static inline __attribute__ ((format (printf, 1, 2)))
> > -int no_printk(const char *s, ...) { return 0; }
> > +int compat_no_printk(const char *s, ...) { return 0; }
> 
> I merged this in. Andy can you review your other changes as Zefir points out?
> 
> mcgrof@frijol ~/compat (git::master)$ gcc --version
> gcc (Debian 4.7.1-2) 4.7.1
> Copyright (C) 2012 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> I suppose we should get ckmake to spit out the version of gcc onto the report.
> 
>   Luis

I did some more testing and I'm not sure I agree that the patch above is
the proper way to do this.  My impression was that what I did was
correct as the only function definitions that need to be renamed with
the 'compat_' string in front were those that were exported.  This is
what was done in both John Linville's initial patch for RHEL support and
the patch from Hauke Mehrtens for Debian Squeeze support.  I feel like
this is the proper patch to fixup my original error:

Subject: [PATCH] compat: fixup error in no_printk definition

What initially looked like a valid definition for the #define for
no_printk was not.  This corrects the problem.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---
 include/linux/compat-2.6.36.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 09e4b6f..cd5e37c 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -99,7 +99,7 @@ struct pm_qos_request_list {
  * gcc's format and side-effect checking.
  */
 /* mask no_printk as RHEL6 backports this */
-#define no_printk(...) compat_no_printk(...)
+#define no_printk(a, ...) compat_no_printk(a, ##__VA_ARGS__)
 static inline __attribute__ ((format (printf, 1, 2)))
 int no_printk(const char *s, ...) { return 0; }
 

