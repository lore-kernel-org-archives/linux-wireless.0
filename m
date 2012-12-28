Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47142 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2L1VrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 16:47:07 -0500
Received: by mail-qc0-f170.google.com with SMTP id d42so5738507qca.29
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2012 13:47:06 -0800 (PST)
Date: Fri, 28 Dec 2012 16:41:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/25] mwifiex: don't use [delayed_]work_pending()
Message-ID: <20121228214115.GE3062@mtj.dyndns.org> (sfid-20121228_224710_904936_D10C41DE)
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-8-git-send-email-tj@kernel.org>
 <477F20668A386D41ADCC57781B1F70430D13D8099B@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D13D8099B@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 22, 2012 at 02:29:57PM -0800, Bing Zhao wrote:
> Hi Tejun,
> 
> Thanks for the patch.
> 
> > Drop work_pending() test from mwifiex_sdio_card_reset().  As
> > work_pending() becomes %false before sdio_card_reset_worker() starts
> > executing, it doesn't really protect anything.  reset_host may change
> > between mmc_remove_host() and mmc_add_host().  Make
> > sdio_card_reset_worker() cache the target mmc_host so that it isn't
> > affected by mwifiex_sdio_card_reset() racing with it.
> > 
> > Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Bing Zhao <bzhao@marvell.com>
> > Cc: linux-wireless@vger.kernel.org
> 
> Acked-by: Bing Zhao <bzhao@marvell.com>
> 
> > ---
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> 
> If you are taking other patches in this series through your tree, please take this one too.

Applied to wq/for-3.9-cleanups.

Thanks.

-- 
tejun
