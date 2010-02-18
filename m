Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41066 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab0BRFJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 00:09:42 -0500
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	 <1266124222.13902.42.camel@mj>
	 <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	 <1266358340.2659.37.camel@mj>
	 <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	 <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
	 <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Feb 2010 23:23:37 -0500
Message-Id: <1266467017.3065.62.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-16 at 16:51 -0800, Luis R. Rodriguez wrote:

> FWIW the two globals can be seen here:
> 
> simple_release_fs(&debugfs_mount, &debugfs_mount_count);
> 
> Not sure how to deal with that.

I think the safest approach would be to reimplement
debugfs_remove_recursive() using only debugfs_remove().  It would only
use the debugfs internals to find the children.  I would even avoid
looking for siblings.

The idea is to descend the directory structure from the top (i.e. the
directory to be removed) to look for a child that is a file or an empty
directory and remove it.  Then start from the top and do the same until
the top directory has no children.  Then remove the top directory.

-- 
Regards,
Pavel Roskin
