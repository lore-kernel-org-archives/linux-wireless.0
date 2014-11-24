Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14254 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaKXQxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 11:53:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add memory dump debugfs interface
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
	<20141124164208.29422.76134.stgit@potku.adurom.net>
Date: Mon, 24 Nov 2014 18:52:58 +0200
In-Reply-To: <20141124164208.29422.76134.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 24 Nov 2014 18:42:08 +0200")
Message-ID: <87mw7g4k2d.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_175325_541836_86AC56FA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> +	ret = copy_from_user(buf, user_buf, count);
> +	if (ret)
> +		goto err_free_copy;
> +
> +	ret = ath10k_hif_diag_write(ar, *ppos, buf, count);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to write address 0x%08x via diagnose window from debugfs: %d\n",
> +			    (u32)(*ppos), ret);
> +		goto err_free_copy;
> +	}
> +
> +	*ppos += count;
> +	ret = count;
> +
> +err_free_copy:
> +	vfree(buf);
> +	return ret;

This introduces a new smatch warning:

drivers/net/wireless/ath/ath10k/debug.c:1100 ath10k_mem_value_write()
warn: maybe return -EFAULT instead of the bytes remaining?

I think it should be like this:

ret = copy_from_user(buf, user_buf, count);
if (ret) {
        ret = -EFAULT;
	goto err_free_copy;
}

Comments?

-- 
Kalle Valo
