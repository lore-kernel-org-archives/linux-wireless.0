Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35480 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832AbcCQMna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 08:43:30 -0400
Message-ID: <1458218602.2158.17.camel@sipsolutions.net> (sfid-20160317_134354_188395_73DC383D)
Subject: Re: [PATCH] iwlwifi: dvm: convert create_singlethread_workqueue()
 to alloc_workqueue()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eva Rachel Retuya <eraretuya@gmail.com>,
	outreachy-kernel@googlegroups.com
Cc: emmanuel.grumbach@intel.com, linuxwifi@intel.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org
Date: Thu, 17 Mar 2016 13:43:22 +0100
In-Reply-To: <1458218246-18807-1-git-send-email-eraretuya@gmail.com> (sfid-20160317_133935_577395_D13DECC0)
References: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
	 (sfid-20160317_133935_577395_D13DECC0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 20:37 +0800, Eva Rachel Retuya wrote:
> Use alloc_workqueue() to allocate the workqueue instead of
> create_singlethread_workqueue() since the latter is deprecated and is
> scheduled for removal.

Scheduled where?

>  static void iwl_setup_deferred_work(struct iwl_priv *priv)
>  {
> -	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
> +	priv->workqueue = alloc_workqueue(DRV_NAME, WQ_HIGHPRI |
> WQ_UNBOUND |
> +					  WQ_MEM_RECLAIM, 1);

Seems like you should use alloc_ordered_workqueue() though? That also
gets you UNBOUND immediately, and the "1".

I'm not really sure HIGHPRI is needed either.

johannes
