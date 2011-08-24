Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50379 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1HXOwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:52:13 -0400
Date: Wed, 24 Aug 2011 20:22:28 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
Message-ID: <20110824145226.GE25267@vasanth-laptop> (sfid-20110824_165216_513992_ED46A935)
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
 <4E550EBD.4040600@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E550EBD.4040600@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 05:46:21PM +0300, Kalle Valo wrote:
> On 08/24/2011 05:25 PM, Vasanthakumar Thiagarajan wrote:
> > +#ifdef CONFIG_ATH6KL_DEBUGFS
> > +int ath6kl_init_debugfs(struct ath6kl *ar)
> > +{
> > +	ar->debugfs_phy = debugfs_create_dir("ath6kl",
> > +					     ar->wdev->wiphy->debugfsdir);
> 
> What if we have multiple devices on same host? Then this won't work,
> right? Maybe we should have some kind of subdirectory under ath6kl or
> something like that.

I don't think we need to worry about multiple device case, it is
entirely different wiphy. May be multiple virtual interface needs to be
taken care?. Anyway, currently ath6kl does not support more than
one virtual interface, can be addressed later.

Vasanth
