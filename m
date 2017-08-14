Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:58794 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752061AbdHNS4M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 14:56:12 -0400
Message-ID: <1502736968.8295.22.camel@perches.com> (sfid-20170814_205616_264116_3868F5B9)
Subject: Re: [PATCH v2 09/10] rtlwifi: use debugfs to debug.
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Mon, 14 Aug 2017 11:56:08 -0700
In-Reply-To: <20170625154344.19213-10-Larry.Finger@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
         <20170625154344.19213-10-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-06-25 at 10:43 -0500, Larry Finger wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Use debugfs to dump register and btcoex status.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
[]
> +void rtl_debug_add_one(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
> +	struct dentry *parent;
> +
> +	snprintf(rtlpriv->dbg.debugfs_name, 18, "%02x-%02x-%02x-%02x-%02x-%02x",
> +		 rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
> +		 rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
> +		 rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);

Why uses dashes and why not just use %pM
