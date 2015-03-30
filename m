Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60598 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbbC3JiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:38:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 5/5] wil6210: update FW file name
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427704134-30699-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Mon, 30 Mar 2015 12:38:08 +0300
In-Reply-To: <1427704134-30699-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 30 Mar 2015 11:28:54 +0300")
Message-ID: <87wq1y6d1b.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_113819_296349_5256615F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Firmware "board" file name has changed from wil6210.board
> to wil6210.brd by the FW generation tools.
>
> Reflect this in the driver.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> index f4681e3..abb2080 100644
> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -33,7 +33,7 @@ extern bool debug_fw;
>  
>  #define WIL_NAME "wil6210"
>  #define WIL_FW_NAME "wil6210.fw" /* code */
> -#define WIL_FW2_NAME "wil6210.board" /* board & radio parameters */
> +#define WIL_FW2_NAME "wil6210.brd" /* board & radio parameters */

I consider the firmware file names as part of stable user space
interface (older user space need to work with newer kernel etc) and this
change breaks that.

-- 
Kalle Valo
