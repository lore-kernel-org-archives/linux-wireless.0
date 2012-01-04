Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:51512 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ADSaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 13:30:15 -0500
Date: Wed, 04 Jan 2012 13:30:12 -0500 (EST)
Message-Id: <20120104.133012.2194053254581656154.davem@davemloft.net> (sfid-20120104_193018_396391_CA56DBF7)
To: vthiagar@qca.qualcomm.com
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Subject: Re: [PATCH] ath6kl: Use a mutex_lock to avoid race in diabling and
 handling irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Date: Wed, 4 Jan 2012 15:57:19 +0530

> Currently this race is handled but in a messy way an atomic
> variable is being checked in a loop which sleeps upto ms
> in every iteration. Remove this logic and use a mutex
> to make sure irq is not disabled when irq handling is in
> progress.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

So you guys have time to code up patches like this but not enough
time to fix the build failure properly that exists in -next for
some time now?

This kind of stuff really drives me nuts, fix your priorities.  You
guys added a build regression to the tree, fix that first.

