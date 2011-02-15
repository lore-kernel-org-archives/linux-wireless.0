Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1BOMIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:08:55 -0500
Subject: Re: [PATCH 2/5] iwlwifi: Convert the tx queue high_mark to an
 atomic_t
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathaniel Smith <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <AANLkTikmsizzK1J=uf4Rp9fkmDdJQ_oKfZV-jUz2sJ18@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-3-git-send-email-njs@pobox.com>
	 <1297685761.3785.38.camel@jlt3.sipsolutions.net>
	 <AANLkTikmsizzK1J=uf4Rp9fkmDdJQ_oKfZV-jUz2sJ18@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 13:08:43 +0100
Message-ID: <1297771723.3935.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 14:35 -0800, Nathaniel Smith wrote:

> > Right -- but it makes the TX path quite a bit more expensive on some
> > architectures. Why is this necessary? There should be locking in most
> > places already, and where not it should be easy to move this under the
> > existing lock.
> 
> Yes, I suspect we could use the priv->lock for this purpose (at the
> expense of adding a lock/unlock on the TX notification path), but I'd
> like some confirmation from someone more familiar with the code before
> trying. high_mark is read from all over the place, and was previously
> read-only, so it really needs someone who understands this driver's
> locking "big picture" to check correctness.

Actually, it doesn't really matter. Linux assumes that reads and writes
to "unsigned long" are always atomic against each other (i.e. you get
either the old or the new value) and that's all you care about here --
this never needs anything like atomic_inc/dec etc.

johannes

