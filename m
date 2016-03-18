Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35398 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcCRUrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 16:47:48 -0400
Date: Fri, 18 Mar 2016 16:47:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Eva Rachel Retuya <eraretuya@gmail.com>
Cc: outreachy-kernel@googlegroups.com, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, linuxwifi@intel.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Outreachy kernel] [PATCH v2] iwlwifi: dvm: use
 alloc_ordered_workqueue()
Message-ID: <20160318204744.GN20028@mtj.duckdns.org> (sfid-20160318_214752_044924_AA6BEB88)
References: <1458231561-13184-1-git-send-email-eraretuya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458231561-13184-1-git-send-email-eraretuya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 12:19:21AM +0800, Eva Rachel Retuya wrote:
> Use alloc_ordered_workqueue() to allocate the workqueue instead of
> create_singlethread_workqueue() since the latter is deprecated and is scheduled
> for removal.
> 
> There are work items doing related operations that shouldn't be swapped when
> queued in a certain order hence preserve the strict execution ordering of a
> single threaded (ST) workqueue by switching to alloc_ordered_workqueue().
> 
> WQ_MEM_RECLAIM flag is not needed since the worker is not supposed to free
> memory.

I think "not depended during memory reclaim" probalby is a better way
to describe it.

> Signed-off-by: Eva Rachel Retuya <eraretuya@gmail.com>

But other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
