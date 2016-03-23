Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbcCWIds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 04:33:48 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eva Rachel Retuya <eraretuya@gmail.com>,
	"outreachy-kernel@googlegroups.com"
	<outreachy-kernel@googlegroups.com>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH v3] iwlwifi: dvm: use alloc_ordered_workqueue()
Date: Wed, 23 Mar 2016 08:33:41 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA8768F@hasmsx107.ger.corp.intel.com> (sfid-20160323_093359_429457_056D902F)
References: <1458364547-11621-1-git-send-email-eraretuya@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/19/2016 07:15 AM, Eva Rachel Retuya wrote:
> Use alloc_ordered_workqueue() to allocate the workqueue instead of
> create_singlethread_workqueue() since the latter is deprecated and is scheduled
> for removal.
> 
> There are work items doing related operations that shouldn't be swapped when
> queued in a certain order hence preserve the strict execution ordering of a
> single threaded (ST) workqueue by switching to alloc_ordered_workqueue().
> 
> WQ_MEM_RECLAIM flag is not needed since the worker is not depended
> during memory reclaim.
> 
> Signed-off-by: Eva Rachel Retuya <eraretuya@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---


Applied - thanks.
