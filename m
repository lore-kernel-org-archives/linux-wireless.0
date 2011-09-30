Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28105 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab1I3Pxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 11:53:41 -0400
Date: Fri, 30 Sep 2011 11:53:06 -0400
From: Pavel Roskin <proski@gnu.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wireless: at76c50x: fix multithread access to hex2str
Message-ID: <20110930115306.3bc105cb@mj> (sfid-20110930_175344_427006_54E6D5A3)
In-Reply-To: <1317293215.2676.111.camel@smile>
References: <21514bff06a915d2edd0a83c74ac512eb8b80b3f.1317215809.git.andriy.shevchenko@linux.intel.com>
	<20110928171909.6889916c@mj>
	<1317293215.2676.111.camel@smile>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 29 Sep 2011 13:46:55 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Wed, 2011-09-28 at 17:19 -0400, Pavel Roskin wrote: 
> > Or maybe you could develop an extension for printk() format that
> > would dump strings of the given length?  Something like %pM, but
> > with an extra argument (and make sure it would not trigger a gcc
> > warning). This way, everybody would benefit.
> I don't think it would be a noticeable benefit. On the other hand
> vsnprintf() is hugely overloaded by many "extensions" to the C99
> variant.

I looked at the code, and it seems very little is needed to support
"%*pM"

> > Please rethink whether it's helpful to send such "fixes" for old and
> > little maintained drivers.
> Last copyright is 2010, TODO list actually suggests to remove hex2str
> at all.

I don't know where it's written, but I think it's a good idea,
especially if there is a better alternative available for all drivers.

-- 
Regards,
Pavel Roskin
