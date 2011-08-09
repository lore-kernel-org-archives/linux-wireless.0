Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15127 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1HIPwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:52:16 -0400
Message-ID: <4E41579F.9040806@qca.qualcomm.com> (sfid-20110809_175220_266532_6CB97D6E)
Date: Tue, 9 Aug 2011 21:21:59 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: Re: [RFC] ath9k: optimize rate control statistics
References: <1312816635-6985-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1312816635-6985-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 August 2011 08:47 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> for ease of debugging, the optimization is done such that the rate
> control stats are shown only for rate's that might be possibly used.
> for instance if static HT20 is configured, showing HT40 rate control
> stats is unnecessary. for dynamic HT40/HT20 i had made it such that the
> stats will be displayed till HT40. double streams/ triple usage was
> also considered. did some basic testing.

I just did further more testing with this patch and found that its 
better to simply use 'rate_table_size' parameter to determine the rate 
table size. with this patch, few times some unnecessary stats were 
showed, when the Access point is configured in legacy mode. will send a 
proper patch for this.

>
> Cc: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
> Cc: "Balasubramanian, senthilkumar"<senthilb@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/rc.c |    8 +++++---
>   1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index c04a6c3..f964473 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1478,13 +1478,15 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
>   	struct ath_rate_priv *rc = file->private_data;
>   	char *buf;
>   	unsigned int len = 0, max;
> -	int i = 0;
> +	u8 i = 0;
> +	static u8 max_rate_table_size;
>   	ssize_t retval;
>
>   	if (rc->rate_table == NULL)
>   		return 0;
> +	max_rate_table_size = max(max_rate_table_size, rc->rate_table_size);
>
> -	max = 80 + rc->rate_table->rate_cnt * 1024 + 1;
> +	max = 80 + max_rate_table_size * 1024 + 1;
>   	buf = kmalloc(max, GFP_KERNEL);
>   	if (buf == NULL)
>   		return -ENOMEM;
> @@ -1494,7 +1496,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
>   		       "HT", "MCS", "Rate",
>   		       "Success", "Retries", "XRetries", "PER");
>
> -	for (i = 0; i<  rc->rate_table->rate_cnt; i++) {
> +	for (i = 0; i<  max_rate_table_size; i++) {
>   		u32 ratekbps = rc->rate_table->info[i].ratekbps;
>   		struct ath_rc_stats *stats =&rc->rcstats[i];
>   		char mcs[5];

