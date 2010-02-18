Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0BRSa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 13:30:59 -0500
Date: Thu, 18 Feb 2010 13:30:58 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
Message-ID: <20100218183058.GG8069@bombadil.infradead.org>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com> <1266124222.13902.42.camel@mj> <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com> <1266358340.2659.37.camel@mj> <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com> <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com> <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com> <1266467017.3065.62.camel@mj> <1266473734.11805.5.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266473734.11805.5.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 01:15:34AM -0500, Pavel Roskin wrote:
> On Wed, 2010-02-17 at 23:23 -0500, Pavel Roskin wrote:
> 
> > The idea is to descend the directory structure from the top (i.e. the
> > directory to be removed) to look for a child that is a file or an empty
> > directory and remove it.  Then start from the top and do the same until
> > the top directory has no children.  Then remove the top directory.
> 
> Here it is.  I tested it by actually replacing the original function in
> wireless-testing.  I checked unloading all wireless drivers.  I also
> tested error handling by keeping a file in debugfs open while removing
> the modules.
> 
> I could compile it against Linux 2.6.26, so it's portable enough for our
> purposes.
> 
> 
> void debugfs_remove_recursive(struct dentry *dentry)
> {
> 	struct dentry *last = NULL;
> 
> 	/* Sanity checks */
> 	if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
> 		return;
> 
> 	while (dentry != last) {
> 		struct dentry *child = dentry;
> 
> 		/* Find a child without children */
> 		while (!list_empty(&child->d_subdirs))
> 			child = list_entry(child->d_subdirs.next, struct dentry,
> 					   d_u.d_child);
> 
> 		/* Bail out if we already tried to remove that entry */
> 		if (child == last)
> 			return;
> 
> 		last = child;
> 		debugfs_remove(child);
> 	}
> }

Sweeet, thanks a lot! I've sucked this into all the respective git trees. This
means we now have backporting re-enabled on bleeding edge for kernels older
than 2.6.27 (whoopdi-free'kin-doo for those who are on those ancient kernels).

  Luis
