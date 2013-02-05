Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33416 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3BERVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 12:21:43 -0500
Message-ID: <51113F98.8040209@candelatech.com> (sfid-20130205_182146_691609_222350FD)
Date: Tue, 05 Feb 2013 09:21:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, qca_vkondrat@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: provide 64-bit traffic counters
References: <1360058204-12208-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1360058204-12208-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 01:56 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> "unsigned long" is already 64-bit on (most?) 64-bit
> machines, use u64 and tell cfg80211 that we provide
> 64-bit counters now.

 From what I can tell, these counters are modified using
+= operators.  From what I recall, this is non-atomic on
32-bit systems when the variable is u64.

Is there any other locking that keeps this from blowing up?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

