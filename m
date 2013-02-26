Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab3BZQYE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 11:24:04 -0500
Date: Tue, 26 Feb 2013 17:05:36 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211:  Fix crash due to un-canceled
 work-items.
Message-ID: <20130226160536.GC5256@redhat.com> (sfid-20130226_172410_719542_EA93379A)
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
 <1361382069-31729-2-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361382069-31729-2-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 09:41:09AM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The monitor_work and beacon_connection_loss_work items were
> not being canceled on disassociation (and not on deletion
> either).  This leads to work-items trying to run after memory
> has been deleted.
[skip]
>  
> +	/* Make sure some work items will not run after this.
> +	 * Have to do this outside the ifmgd->mtx lock.
> +	 */
> +	cancel_work_sync(&ifmgd->monitor_work);
> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);

Other works should be canceled as well. Ben, could you repost
this patch with proper comment?

Stanislaw
