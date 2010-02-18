Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58070 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0BRGPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 01:15:46 -0500
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1266467017.3065.62.camel@mj>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	 <1266124222.13902.42.camel@mj>
	 <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	 <1266358340.2659.37.camel@mj>
	 <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	 <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
	 <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
	 <1266467017.3065.62.camel@mj>
Content-Type: text/plain
Date: Thu, 18 Feb 2010 01:15:34 -0500
Message-Id: <1266473734.11805.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-17 at 23:23 -0500, Pavel Roskin wrote:

> The idea is to descend the directory structure from the top (i.e. the
> directory to be removed) to look for a child that is a file or an empty
> directory and remove it.  Then start from the top and do the same until
> the top directory has no children.  Then remove the top directory.

Here it is.  I tested it by actually replacing the original function in
wireless-testing.  I checked unloading all wireless drivers.  I also
tested error handling by keeping a file in debugfs open while removing
the modules.

I could compile it against Linux 2.6.26, so it's portable enough for our
purposes.


void debugfs_remove_recursive(struct dentry *dentry)
{
	struct dentry *last = NULL;

	/* Sanity checks */
	if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
		return;

	while (dentry != last) {
		struct dentry *child = dentry;

		/* Find a child without children */
		while (!list_empty(&child->d_subdirs))
			child = list_entry(child->d_subdirs.next, struct dentry,
					   d_u.d_child);

		/* Bail out if we already tried to remove that entry */
		if (child == last)
			return;

		last = child;
		debugfs_remove(child);
	}
}

-- 
Regards,
Pavel Roskin
