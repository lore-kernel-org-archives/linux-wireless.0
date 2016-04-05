Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:42624 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756913AbcDER3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 13:29:01 -0400
Message-ID: <1459877336.6715.6.camel@perches.com> (sfid-20160405_192905_881126_39395FC4)
Subject: Re: [PATCH] ath10k: Fix return value for btcoex and peer stats
 debugfs
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org, Yanbo Li <yanbol@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, kvalo@codeaurora.org,
	mohammed@codeaurora.org, linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 10:28:56 -0700
In-Reply-To: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1459870106-2694-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-05 at 20:58 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Return value is incorrect for btcoex and peer stats debugfs
> 'write' entries if the user provides a value that matches with
> the already available debugfs entry, this results in the debugfs
> entry getting stuck and the operation has to be terminated manually.
> Fix this by returning the appropriate return 'count' as we do it for
> other debugfs entries like pktlog etc

Not your code, but some of the xor uses are odd at best.

> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
[]
> @@ -2122,7 +2122,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
>  	struct ath10k *ar = file->private_data;
>  	char buf[32];
>  	size_t buf_size;
> -	int ret = 0;
> +	int ret;
>  	bool val;
>  
>  	buf_size = min(count, (sizeof(buf) - 1));
> @@ -2142,8 +2142,10 @@ static ssize_t ath10k_write_btcoex(struct file *file,
>  		goto exit;
>  	}
>  
> -	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
> +	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val)) {

xor on an int and a bool.

> @@ -2189,7 +2191,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
>  	struct ath10k *ar = file->private_data;
>  	char buf[32];
>  	size_t buf_size;
> -	int ret = 0;
> +	int ret;
>  	bool val;
>  
>  	buf_size = min(count, (sizeof(buf) - 1));
> @@ -2209,8 +2211,10 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
>  		goto exit;
>  	}
>  
> -	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val))
> +	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val)) {

here too

