Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1DSMWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:22:03 -0400
Subject: Re: [PATCH 03/10] iwlagn: verify that huge commands are synchronous
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20110419120303.GB2220@redhat.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1303145057-6545-4-git-send-email-wey-yi.w.guy@intel.com>
	 <20110419120303.GB2220@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 14:21:58 +0200
Message-ID: <1303215718.3603.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 14:03 +0200, Stanislaw Gruszka wrote:
> On Mon, Apr 18, 2011 at 09:44:10AM -0700, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Since huge commands all share a single buffer,
> > there can only be a single one in flight at a
> > time since otherwise they'd overwrite each
> > other. This is true in the driver now, but it
> > seems like a possible source of bugs, so add
> > a test to verify that huge commands are always
> > sent synchronously.
> 
> I belive WARN_ON(out_meta->flags & CMD_MAPPED) I added, protect from
> overwite huge commands buffer already.

Yup, that's (almost) true. I wrote this patch before yours were merged,
they just crossed in our tree.

With only your patch though an asynchronous HUGE command can still
succeed, unless there are two at the same time. Mine makes it always
warn and fail, which is what we want, because otherwise you might not
notice right away that it could clash.

johannes

