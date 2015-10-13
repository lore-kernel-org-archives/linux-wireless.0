Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51475 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbbJMInY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 04:43:24 -0400
Message-ID: <1444725801.1961.5.camel@sipsolutions.net> (sfid-20151013_104329_389745_8F061EC2)
Subject: Re: [PATCH v2 1/2] cfg80211: Add multiple scan plans for scheduled
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 13 Oct 2015 10:43:21 +0200
In-Reply-To: <1444632695-10505-1-git-send-email-luca@coelho.fi>
References: <1444632695-10505-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-12 at 09:51 +0300, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Add the option to configure multiple 'scan plans' for scheduled scan.
> Each 'scan plan' defines the number of scan cycles and the interval
> between scans. The scan plans are executed in the order they were
> configured. The last scan plan will always run infinitely and thus
> defines only the interval between scans.
> The maximum number of scan plans supported by the device and the
> maximum number of iterations in a single scan plan are advertised
> to userspace so it can configure the scan plans appropriately.
> 
> When scheduled scan results are received there is no way to know 
> which
> scan plan is being currently executed, so there is no way to know 
> when
> the next scan iteration will start. This is not a problem, however.
> The scan start timestamp is only used for flushing old scan results,
> and there is no difference between flushing all results received 
> until
> the end of the previous iteration or the start of the current one,
> since no results will be received in between.
> 
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
> 
> In v2:
>    * take care of all drivers that use the 
> cfg80211_sched_scan_request struct;
> 
Both applied.

johannes
