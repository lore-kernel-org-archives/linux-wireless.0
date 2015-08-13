Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbHMMZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:25:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_htc: match wait_for_completion_timeout return type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431617394-30725-1-git-send-email-hofrat@osadl.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Message-Id: <20150813122533.52E091402D5@smtp.codeaurora.org> (sfid-20150813_142550_432039_03EA732C)
Date: Thu, 13 Aug 2015 12:25:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Return type of wait_for_completion_timeout is unsigned long not int.
> As time_left is exclusively used for wait_for_completion_timeout here its
> type is simply changed to unsigned long.
> 
> API conformance testing for completions with coccinelle spatches are being
> used to locate API usage inconsistencies:
> ./drivers/net/wireless/ath/ath9k/htc_hst.c:171
> 	int return assigned to unsigned long
> ./drivers/net/wireless/ath/ath9k/htc_hst.c:277
> 	int return assigned to unsigned long
> ./drivers/net/wireless/ath/ath9k/htc_hst.c:206
> 	int return assigned to unsigned long
> 
> Patch was compile tested with x86_64_defconfig + CONFIG_ATH_CARDS=m,
> CONFIG_ATH9K_HTC=m
> 
> Patch is against 4.1-rc3 (localversion-next is -next-20150514)
> 
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
