Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49055 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbcLEUuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 15:50:21 -0500
Date: Mon, 5 Dec 2016 23:49:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        shaofu <shaofu@realtek.com>, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/14] rtlwifi: Fix programing CAM content sequence.
Message-ID: <20161205204954.GH8176@mwanda> (sfid-20161205_215030_695526_2D8F48B6)
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
 <20161202014833.6856-3-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161202014833.6856-3-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 01, 2016 at 07:48:21PM -0600, Larry Finger wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> There is a potential race condition when the control byte of a CAM
> entry is written first. Write in reverse order to correct the condition.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: shaofu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/realtek/rtlwifi/cam.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
> index 8fe8b4c..5d58ec0 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/cam.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
> @@ -45,12 +45,13 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
>  
>  	u32 target_command;
>  	u32 target_content = 0;
> -	u8 entry_i;
> +	s8 entry_i;

Just make this an int.  s8 is for very specific things like hardware
registers.

regards,
dan carpenter
