Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdHPOy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 10:54:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v2 1/2] rtlwifi: use debugfs to debug.
References: <20170810164744.9336-1-Larry.Finger@lwfinger.net>
        <20170810164744.9336-2-Larry.Finger@lwfinger.net>
Date: Wed, 16 Aug 2017 17:54:21 +0300
In-Reply-To: <20170810164744.9336-2-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Thu, 10 Aug 2017 11:47:43 -0500")
Message-ID: <87efsbtvfm.fsf@purkki.adurom.net> (sfid-20170816_165434_076560_75FB495A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> Use debugfs to dump register and btcoex status.
>
> We create topdir in /sys/kernel/debug/rtlwifi/, and use the MAC address
> as subdirectory with several entries to dump mac_reg, bb_reg, rf_reg etc.
> An example is
>     /sys/kernel/debug/rtlwifi/00-11-22-33-44-55-66/mac_0
>
> This change permits examination of device registers in a dynamic manner,
> a feature not available with the current debug mechanism.

Not just dump but apparently also to write to registers, I see a
write_reg file there which takes commands like "h2c", "rf" and none
meaning BB/MAC registers. IMHO it would be cleaner to have separate files
for each register type, currently rtl_debugfs_set_write_reg() is pretty
ugly.

> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> +static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
> +					 const char __user *buffer,
> +					 size_t count, loff_t *loff)
> +{
> +	struct rtl_debgufs_priv *debugfs_priv = filp->private_data;
> +	struct rtl_priv *rtlpriv = debugfs_priv->rtlpriv;
> +	struct ieee80211_hw *hw = rtlpriv->hw;
> +	char tmp[32 + 1];
> +	int tmp_len;
> +	u32 addr, val, len;
> +	int num;
> +
> +	if (count < 3) {
> +		/*printk("argument size is less than 3\n");*/
> +		return -EFAULT;
> +	}

Commented out code. I saw few other cases in this patch also.

-- 
Kalle Valo
