Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44808 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZHRNM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 09:12:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] b43: Fix sparse warnings
Date: Tue, 18 Aug 2009 15:12:56 +0200
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net> <200908151204.11024.mb@bu3sch.de> <1250541041.10511.10.camel@mj>
In-Reply-To: <1250541041.10511.10.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908181512.56841.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 17 August 2009 22:30:41 Pavel Roskin wrote:
> On Sat, 2009-08-15 at 12:04 +0200, Michael Buesch wrote:
> 
> > I still do not understand why it does complain about an _explicit_ truncation.
> > That's simply stupid. If I program an explicit truncation I _do_ mean to truncate the value.
> 
> Actually, it's a bug in sparse.  Sparse acts inconsistently.
> 
> This causes a warning:
> 
> void mask(unsigned short mask);
> static void test(void)
> {
>         mask((unsigned short)0xffff0000);
> }
> 
> test.c:4:30: warning: cast truncates bits from constant value (ffff0000
> becomes 0)
> 
> But this is OK:
> 
> void mask(unsigned short mask);
> static void test(void)
> {
>         mask((unsigned short)0xfffff000);
> }
> 
> Moreover, this is OK, even though the cast changes the value of the
> constant:
> 
> void mask(unsigned short mask);
> static void test(void)
> {
>         mask((unsigned short)0xfffff000U);
> }
> 
> I suggest that we take no action until sparse is fixed.  I'm going to
> report the issue to the sparse mailing list now.
> 

Cool, thanks a lot for tracking this down. :)

-- 
Greetings, Michael.
