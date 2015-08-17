Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38571 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbbHQOnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:43:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wil6210: match wait_for_completion_timeout return type
References: <1431603686-24029-1-git-send-email-hofrat@osadl.org>
Date: Mon, 17 Aug 2015 17:42:51 +0300
In-Reply-To: <1431603686-24029-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Thu, 14 May 2015 13:41:26 +0200")
Message-ID: <87io8edlhw.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_164328_325967_B8BEAC5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Return type of wait_for_completion_timeout is unsigned long not int.
> As remain is exclusively used for wait_for_completion_timeout here its
> type is simply changed to unsigned long.
>
>
> API conformance testing for completions with coccinelle spatches are being
> used to locate API usage inconsistencies:
> ./drivers/net/wireless/ath/wil6210/wmi.c:827 
> 	int return assigned to unsigned long
>
> Patch was compile tested with x86_64_defconfig + CONFIG_ATH_CARDS=m,
> CONFIG_WIL6210=m
>
> Patch is against 4.1-rc3 (localversion-next is -next-20150514)
>
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied to ath.git.

-- 
Kalle Valo
