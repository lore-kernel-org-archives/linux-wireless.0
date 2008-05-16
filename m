Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYEPOJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:09:14 -0400
Subject: Re: [PATCH stable] libertas: Extend CMD_MESH_CONFIG to get and set
	persistent mesh default params.
From: David Woodhouse <dwmw2@infradead.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: devel@laptop.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>,
	Javier Cardona <javier@cozybit.com>,
	Ricardo Carrano <carrano@ricardocarrano.com>
In-Reply-To: <482c8eb8.0b97600a.08e2.ffff8ee3@mx.google.com>
References: <482c8eb8.0b97600a.08e2.ffff8ee3@mx.google.com>
Content-Type: text/plain
Date: Fri, 16 May 2008 15:09:09 +0100
Message-Id: <1210946949.3008.16.camel@pmac.infradead.org> (sfid-20080516_160924_625301_06CD189B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-15 at 11:01 -0700, Brian Cavagnolo wrote:
> This patch is based on a patch from Shailendra Govardhan.  It introduces
> several new iwprivs: {get,set}_bootflag {get,set}_boottime {get,set}_def_chan
> {get,set}_def_protid {get,set}_def_metid {get,set}_def_meshcap
> {get,set}_def_meshid.  These commands are only supported on Marvell hardware
> that implements persistent defaults, such as the OLPC Active Antenna.
> Accordingly, this patch may not be suitable for upstream merging.
> 
> See http://dev.laptop.org/ticket/6823 for minimal testing results and known
> issues.  See http://www.laptop.org/teamwiki/index.php/Tech:Wireless#Firmware_image_which_stores_the_mesh_parameters_in_flash for iwpriv documentation.
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> ---

Hm. I was intending to veto the addition of any more private ioctls to
the olpc tree, because they all need fixing to use cfg80211 or something
else upstream, and we only make pain for ourselves by adding to the
divergence -- adding new APIs to userspace when we _know_ are going to
have to change them is just silly.

But this is the _one_ thing which might actually be OK to do with a
private ioctl, since it's very hardware-specific. Unlike like all the
mesh-mangling stuff where we really ought to be compatible with o11s.

So maybe, just maybe, we _can_ do this with iwpriv and push that
upstream.

If you want to revamp the patch to apply to the upstream kernel and see
what people think of it, go ahead.

-- 
dwmw2

