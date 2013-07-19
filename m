Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26384 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934500Ab3GSK34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 06:29:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] ath10k: create debugfs interface to trigger fw crash
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
	<1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
	<1373961277-14784-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 13:29:46 +0300
In-Reply-To: <1373961277-14784-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 16 Jul 2013 09:54:37 +0200")
Message-ID: <87zjti4zc5.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_122959_734827_E20DBF62)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This can be useful for testing. To perform a
> forced firmware crash write 'crash' to
> 'simulate_fw_crash' debugfs file. E.g.
>
>   echo crash > /sys/kernel/debug/ieee80211/phy1/ath10k/simulate_fw_crash
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
> +					      const char __user *user_buf,
> +					      size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	char buf[32] = {};
> +	int ret;
> +
> +	mutex_lock(&ar->conf_mutex);
> +
> +	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
> +	if (strcmp(buf, "crash") && strcmp(buf, "crash\n")) {
> +		ath10k_warn("write keyword `crash` to simulate firmware crash\n");
> +		goto exit;
> +	}

Better to just return an error here.

> +	if (ar->state != ATH10K_STATE_ON &&
> +	    ar->state != ATH10K_STATE_RESTARTED) {
> +		ath10k_warn("firmware isn't loaded yet, nothing to crash\n");
> +		goto exit;
> +	}

Ditto.

-- 
Kalle Valo
