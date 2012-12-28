Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40545 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2L1VsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 16:48:11 -0500
Received: by mail-qc0-f182.google.com with SMTP id k19so5598223qcs.41
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2012 13:48:11 -0800 (PST)
Date: Fri, 28 Dec 2012 16:42:18 -0500
From: Tejun Heo <tj@kernel.org>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/25] wl1251: don't use [delayed_]work_pending()
Message-ID: <20121228214218.GG3062@mtj.dyndns.org> (sfid-20121228_224814_715548_629EE065)
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-10-git-send-email-tj@kernel.org>
 <1356185669.20841.9.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356185669.20841.9.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 22, 2012 at 04:14:29PM +0200, Luciano Coelho wrote:
> On Fri, 2012-12-21 at 17:56 -0800, Tejun Heo wrote:
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> > 
> > Remove unnecessary pending tests from wl1251.  Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Luciano Coelho <coelho@ti.com>
> > Cc: linux-wireless@vger.kernel.org
> > ---
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> > 
> > Thanks.
> 
> It's probably easier if you take it via your tree.  This driver doesn't
> get patches very often, so I doubt there will be any conflicts.
> 
> Thank you!
> 
> Acked-by: Luciano Coelho <coelho@ti.com>

Applied to wq/for-3.9-cleanups.  Thanks.

-- 
tejun
