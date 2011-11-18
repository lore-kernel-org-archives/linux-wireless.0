Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47075 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1KRWp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:45:28 -0500
Date: Fri, 18 Nov 2011 17:34:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
Message-ID: <20111118223445.GA5642@tuxdriver.com> (sfid-20111118_234531_972115_2C250B8C)
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
 <1321655181.2367.1.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321655181.2367.1.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 02:26:21PM -0800, Joe Perches wrote:
> On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
> > The way the compat-* header files are included causes the default
> > pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
> > Files that define pr_fmt then generate a lot of build SPAM about
> > pr_fmt being redefined.
> > 
> > Eliminate the build noise by preemptively undefining pr_fmt in those
> > files that define it.  This is accomplished by adding a patch to the
> > patches directory.
> 
> Why not undef pr_fmt after the compat-* headers?

That caused a build break.  IIRC, not everyone that uses pr_*
defines pr_fmt.  If pr_fmt is undef'd then they don't compile.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
