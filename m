Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48210 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYL0JT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 04:19:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] wireless-regdb: Add install target to Makefile
Date: Sat, 27 Dec 2008 10:19:00 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis Rodriguez <mcgrof@gmail.com>
References: <200812262342.57675.mb@bu3sch.de> <1230360174.2633.15.camel@dv>
In-Reply-To: <1230360174.2633.15.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812271019.00467.mb@bu3sch.de> (sfid-20081227_101936_120973_959D3B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 December 2008 07:42:54 Pavel Roskin wrote:
> On Fri, 2008-12-26 at 23:42 +0100, Michael Buesch wrote:
> > +install:
> > +	-install -o 0 -g 0 -m 644 regulatory.bin $(PREFIX)/lib/crda/regulatory.bin
> 
> The directory should be created first.  Most likely it doesn't exist.
> 
> Also, the minus in front of the "install" command is harmful.  Errors
> should not be ignored.  If the file is not installed, "make install"
> should fail.
> 
> "install -D" is not widely used in makefiles, so let's do it in two
> steps.  $(PREFIX)/lib/crda/ could be abstracted as another variable.
> 
> Here's my take:

ok thanks

-- 
Greetings, Michael.
