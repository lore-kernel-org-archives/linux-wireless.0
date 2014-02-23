Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:48930 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751763AbaBWUKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 15:10:36 -0500
Message-ID: <1393186232.11020.6.camel@joe-AO722> (sfid-20140223_211041_870751_106D08C8)
Subject: Re: [PATCH 13/17] iwlwifi: mvm: add Rx frames statistics via debugfs
From: Joe Perches <joe@perches.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Sun, 23 Feb 2014 12:10:32 -0800
In-Reply-To: <1393185428-8524-13-git-send-email-egrumbach@gmail.com>
References: <530A51A4.6000007@gmail.com>
	 <1393185428-8524-13-git-send-email-egrumbach@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-23 at 21:57 +0200, Emmanuel Grumbach wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> Collect statistics regarding rates and aggregations in Rx
> frames and export the data via debugfs.
[]
> diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
[]
> +static ssize_t iwl_dbgfs_frame_stats_read(struct iwl_mvm *mvm,
> +					  char __user *user_buf, size_t count,
> +					  loff_t *ppos,
> +					  struct iwl_mvm_frame_stats *stats)
> +{
> +	char *buff;
> +	int pos = 0, idx, i;

I think this would be shorter code using pos as a char *

> +	int ret;
> +	size_t bufsz = 1024;

I'd prefer #define or static const though the compiler
should do the same thing.

> +	buff = kmalloc(bufsz, GFP_KERNEL);
> +	if (!buff)
> +		return -ENOMEM;
> +
> +	spin_lock_bh(&mvm->drv_stats_lock);

	pos = buff;
	endpos = pos + bufsz;

> +	pos += scnprintf(buff + pos, bufsz - pos,
> +			 "Legacy/HT/VHT\t:\t%d/%d/%d\n",
> +			 stats->legacy_frames,
> +			 stats->ht_frames,
> +			 stats->vht_frames);

	pos += scnprintf(pos, endpos - pos, etc...

etc...


