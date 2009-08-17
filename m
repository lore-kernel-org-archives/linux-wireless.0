Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62464 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbZHQUao (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:30:44 -0400
Subject: Re: [PATCH] b43: Fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200908151204.11024.mb@bu3sch.de>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
	 <69e28c910908141404q42685aebo93718a7504020c06@mail.gmail.com>
	 <1250285729.8137.48.camel@mj>  <200908151204.11024.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 16:30:41 -0400
Message-Id: <1250541041.10511.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-08-15 at 12:04 +0200, Michael Buesch wrote:

> I still do not understand why it does complain about an _explicit_ truncation.
> That's simply stupid. If I program an explicit truncation I _do_ mean to truncate the value.

Actually, it's a bug in sparse.  Sparse acts inconsistently.

This causes a warning:

void mask(unsigned short mask);
static void test(void)
{
        mask((unsigned short)0xffff0000);
}

test.c:4:30: warning: cast truncates bits from constant value (ffff0000
becomes 0)

But this is OK:

void mask(unsigned short mask);
static void test(void)
{
        mask((unsigned short)0xfffff000);
}

Moreover, this is OK, even though the cast changes the value of the
constant:

void mask(unsigned short mask);
static void test(void)
{
        mask((unsigned short)0xfffff000U);
}

I suggest that we take no action until sparse is fixed.  I'm going to
report the issue to the sparse mailing list now.

-- 
Regards,
Pavel Roskin
