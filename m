Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51954 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1AJPTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 10:19:31 -0500
Message-ID: <4D2B2377.1070600@openwrt.org>
Date: Mon, 10 Jan 2011 08:19:19 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH RESEND 11/11] ath9k: Implement rx copy-break.
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com> <1294643513-18820-12-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-12-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-10 12:11 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This saves us constantly allocating large, multi-page
> skbs.  It should fix the order-1 allocation errors reported,
> and in a 60-vif scenario, this significantly decreases CPU
> utilization, and latency, and increases bandwidth.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
I think we should use Jouni's approach instead of this patch, as it also 
fixes order-1 allocations, but with less data copying involved.

- Felix
