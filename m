Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdA1GzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 01:55:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH 11/11] rtlwifi: Add work queue for c2h cmd.
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
        <20170120212716.29887-12-Larry.Finger@lwfinger.net>
Date: Sat, 28 Jan 2017 08:55:05 +0200
In-Reply-To: <20170120212716.29887-12-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Fri, 20 Jan 2017 15:27:16 -0600")
Message-ID: <87ziibfzcm.fsf@purkki.adurom.net> (sfid-20170128_080002_540767_09FBE6CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> btcoex needs to sleep, thus it must run in thread context.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

[...]

> +void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	unsigned long flags;
> +	struct rtl_c2hcmd *c2hcmd;
> +
> +	while (true) {
> +		/* dequeue a task */
> +		spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
> +
> +		c2hcmd = list_first_entry_or_null(&rtlpriv->c2hcmd_list,
> +						  struct rtl_c2hcmd, list);
> +
> +		if (c2hcmd)
> +			list_del(&c2hcmd->list);
> +
> +		spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
> +
> +		/* do it */
> +		if (!c2hcmd)
> +			break;
> +
> +		if (rtlpriv->cfg->ops->c2h_content_parsing && exec)
> +			rtlpriv->cfg->ops->c2h_content_parsing(hw,
> +					c2hcmd->tag, c2hcmd->len, c2hcmd->val);
> +
> +		/* free */
> +		kfree(c2hcmd->val);
> +
> +		kfree(c2hcmd);
> +	}
> +}

Never ending loops are not really preferred in kernel, with a simple bug
it could cause annoying system-wide problems. Can you add a some sort of
failsafe mechanism, for example bailing out from the loop if it has been
running more than 200 ms or something like that?

-- 
Kalle Valo
