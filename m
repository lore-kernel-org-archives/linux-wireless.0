Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbcEJQk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 12:40:59 -0400
Date: Tue, 10 May 2016 22:10:49 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix 10.4 extended peer stats update
Message-ID: <20160510164049.GC21638@atheros-ThinkPad-T61> (sfid-20160510_184102_572838_70530E15)
References: <1462897645-16219-1-git-send-email-mohammed@qca.qualcomm.com>
 <57320DAF.2040508@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57320DAF.2040508@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2016 at 09:34:55AM -0700, Ben Greear wrote:
> On 05/10/2016 09:27 AM, Mohammed Shafi Shajakhan wrote:
> >From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> >10.4 'extended peer stats' will be not be appended with normal peer stats
> >data and they shall be coming in separate chunks. Fix this by maintaining
> >a separate linked list 'extender peer stats' for 10.4 and update
> >rx_duration for per station statistics. Also parse through beacon filter
> >(if enabled), to make sure we parse the extended peer stats properly.
> >This issue was exposed when more than one client is connected and
> >extended peer stats for 10.4 is enabled
> 
> In general, maybe more of these stats should be kept in the driver instead
> of the firmware?  The firmware is very tight on RAM already, and if
> we can pass the needed info back to the host, it could gather arbitrary
> amounts of stats as needed.
>

[shafi] agreed, probably thats why we are tracking u64 counters like rx_duration
etc in host while the firmware variable will wrap aroud in sometime

regards,
shafi
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
