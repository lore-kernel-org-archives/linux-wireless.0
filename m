Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34794 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbcEJQe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 12:34:57 -0400
Subject: Re: [PATCH] ath10k: Fix 10.4 extended peer stats update
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org
References: <1462897645-16219-1-git-send-email-mohammed@qca.qualcomm.com>
Cc: mohammed@codeaurora.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <57320DAF.2040508@candelatech.com> (sfid-20160510_183511_127848_F989D32C)
Date: Tue, 10 May 2016 09:34:55 -0700
MIME-Version: 1.0
In-Reply-To: <1462897645-16219-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2016 09:27 AM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> 10.4 'extended peer stats' will be not be appended with normal peer stats
> data and they shall be coming in separate chunks. Fix this by maintaining
> a separate linked list 'extender peer stats' for 10.4 and update
> rx_duration for per station statistics. Also parse through beacon filter
> (if enabled), to make sure we parse the extended peer stats properly.
> This issue was exposed when more than one client is connected and
> extended peer stats for 10.4 is enabled

In general, maybe more of these stats should be kept in the driver instead
of the firmware?  The firmware is very tight on RAM already, and if
we can pass the needed info back to the host, it could gather arbitrary
amounts of stats as needed.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

