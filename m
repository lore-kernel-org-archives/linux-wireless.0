Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:56171 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754148Ab3J2RZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 13:25:05 -0400
Message-ID: <1383067501.12439.5.camel@joe-AO722> (sfid-20131029_182509_229567_2381EAD2)
Subject: Re: [PATCH 1/3] ath10k: add phyerr/dfs handling
From: Joe Perches <joe@perches.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Tue, 29 Oct 2013 10:25:01 -0700
In-Reply-To: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-29 at 13:06 +0100, Marek Puzyniak wrote:
> Handle phyerr, dfs event, radar_report and fft_report.
> Add also debugfs dfs_simulate_radar and dfs_stats files.
> Use ath dfs pattern detector.

Just some simple notes:

> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
[]
> +#define ATH10K_DFS_STAT(s, p) (\
> +	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
> +			 ar->debug.dfs_stats.p))
> +
> +#define ATH10K_DFS_POOL_STAT(s, p) (\
> +	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
> +			 ar->debug.dfs_pool_stats.p))

You've already got sizes for the description field
might as well use %-28s

> +static ssize_t ath10k_read_file_dfs(struct file *file, char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	int retval = 0, size = 8000, len = 0;

size should either be a #define or a const

[]

> +	len += scnprintf(buf + len, size - len, "Pulse detector statistics:\n");
> +	ATH10K_DFS_STAT("reported phy errors     ", phy_errors);
> +	ATH10K_DFS_STAT("pulse events reported   ", pulses_total);
> +	ATH10K_DFS_STAT("DFS pulses detected     ", pulses_detected);
> +	ATH10K_DFS_STAT("DFS pulses discarded    ", pulses_discarded);
> +	ATH10K_DFS_STAT("Radars detected         ", radar_detected);
> +
> +	len += scnprintf(buf + len, size - len, "Global Pool statistics:\n");
> +	ATH10K_DFS_POOL_STAT("Pool references         ", pool_reference);
> +	ATH10K_DFS_POOL_STAT("Pulses allocated        ", pulse_allocated);
> +	ATH10K_DFS_POOL_STAT("Pulses alloc error      ", pulse_alloc_error);
> +	ATH10K_DFS_POOL_STAT("Pulses in use           ", pulse_used);
> +	ATH10K_DFS_POOL_STAT("Seqs. allocated         ", pseq_allocated);
> +	ATH10K_DFS_POOL_STAT("Seqs. alloc error       ", pseq_alloc_error);
> +	ATH10K_DFS_POOL_STAT("Seqs. in use            ", pseq_used);

If using %-28s, the trailing quoted spaces can be removed.


