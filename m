Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36158 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdG0KYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:24:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 09/10] rtlwifi: use debugfs to debug.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-10-Larry.Finger@lwfinger.net>
Date: Thu, 27 Jul 2017 13:24:16 +0300
In-Reply-To: <20170702181239.17911-10-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 2 Jul 2017 13:12:38 -0500")
Message-ID: <87r2x2w52n.fsf@purkki.adurom.net> (sfid-20170727_122424_299047_DE4EB6D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> Use debugfs to dump register and btcoex status. The kbuild test robot
> <lkp@intel.com> suggested a change to use simple_open() instead of
> a local routine.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> +	if (count < 3) {
> +		/*printk("argument size is less than 3\n");*/
> +		return -EFAULT;
> +	}

> +	if (num !=  3) {
> +		/*printk("invalid write_reg parameter!\n");*/
> +		return count;
> +	}

> +	default:
> +		/*printk("error write length=%d", len);*/
> +		break;
> +	}

Dead code.

> +	/* add for debug */
> +	rtl_debug_add_one(hw);

> +	/* remove form debug */
> +	rtl_debug_remove_one(hw);

The comments are useless, the function name already tells the same.

-- 
Kalle Valo
