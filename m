Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46564 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbHYMKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:10:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] ath9k_htc: do ani shortcalibratio if we got -ETIMEDOUT
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1439529399-3094-1-git-send-email-linux@rempel-privat.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Oleksij Rempel <linux@rempel-privat.de>
Message-Id: <20150825121025.33373140271@smtp.codeaurora.org> (sfid-20150825_141030_996480_446BFCA0)
Date: Tue, 25 Aug 2015 12:10:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> current code will handle -ETIMEDOUT as success which is probalbly wrong.
> 
> According to this comment I assume it is safe to handle -ETIMEDOUT as false:
> drivers/net/wireless/ath/ath9k/calib.c
> 290         /*
> 291          * We timed out waiting for the noisefloor to load, probably due to an
> 292          * in-progress rx. Simply return here and allow the load plenty of time
> 293          * to complete before the next calibration interval.  We need to avoid
> 294          * trying to load -50 (which happens below) while the previous load is
> 295          * still in progress as this can cause rx deafness. Instead by returning
> 296          * here, the baseband nf cal will just be capped by our present
> 297          * noisefloor until the next calibration timer.
> 298          */
> 
> Since no other error wariants are present, this patch is checking only
> for (ret <= 0).
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
