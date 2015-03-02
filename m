Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58585 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbbCBIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 03:25:03 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Message-ID: <54F41E4F.8090502@qca.qualcomm.com> (sfid-20150302_092620_990723_55BCB871)
Date: Mon, 2 Mar 2015 10:24:47 +0200
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	<netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wil6210: increase cmd buffer size to avoid sscanf buffer
 overflow
References: <1425232113-5010-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1425232113-5010-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2015 07:48 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> cppcheck detected a buffer overflow:
>
> [drivers/net/wireless/ath/wil6210/debugfs.c:634]: (error) Width 8
>    given in format string (no. 1) is larger than destination buffer
>    'cmd[8]', use %7s to prevent overflowing it.
>
> For the current %8s sscanf we require cmd to be 9 chars long
> so increase it by 1 byte to prevent the sscan overflow (rather
> than reduce the %8s specifier to %7s as cppcheck recommends).
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index 45c3558e..29aab12 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -618,7 +618,7 @@ static ssize_t wil_write_back(struct file *file, const char __user *buf,
>   	struct wil6210_priv *wil = file->private_data;
>   	int rc;
>   	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
> -	char cmd[8];
> +	char cmd[9];
>   	int p1, p2, p3;
>
>   	if (!kbuf)
>
Thanks for finding this. Here is my
Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, Vladimir
