Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1181 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaK3I3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 03:29:13 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Lino Sanfilippo <LinoSanfilippo@gmx.de>, <netdev@vger.kernel.org>,
	<ahmedtamrawi@gmail.com>, <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wil6210: Fix potential memory leaks on error paths
Date: Sun, 30 Nov 2014 10:28:39 +0200
Message-ID: <3345120.HXl93bohCX@lx-wigig-72> (sfid-20141130_092919_133651_C46C48BA)
In-Reply-To: <1417139239-32602-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417139239-32602-1-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 28, 2014 02:47:19 AM Lino Sanfilippo wrote:
> Fix missing memory deallocation on error paths in wil_write_file_wmi()
> and wil_write_file_txmgmt().
> 
> Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index 54a6ddc..4e6e145 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -573,8 +573,10 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
>  	if (!frame)
>  		return -ENOMEM;
>  
> -	if (copy_from_user(frame, buf, len))
> +	if (copy_from_user(frame, buf, len)) {
> +		kfree(frame);
>  		return -EIO;
> +	}
>  
>  	params.buf = frame;
>  	params.len = len;
> @@ -614,8 +616,10 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
>  		return -ENOMEM;
>  
>  	rc = simple_write_to_buffer(wmi, len, ppos, buf, len);
> -	if (rc < 0)
> +	if (rc < 0) {
> +		kfree(wmi);
>  		return rc;
> +	}
>  
>  	cmd = &wmi[1];
>  	cmdid = le16_to_cpu(wmi->id);
> 

Lino and Ahmed: thanks for that. Here is my
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

John: please merge
