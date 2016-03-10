Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbcCJO0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:26:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 042/113] rtl8xxxu: Initial implementation of rtl8723bu_config_channel()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-43-git-send-email-Jes.Sorensen@redhat.com>
Date: Thu, 10 Mar 2016 16:26:11 +0200
In-Reply-To: <1456783551-28315-43-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Mon, 29 Feb 2016 17:04:40 -0500")
Message-ID: <87y49qjtoc.fsf@purkki.adurom.net> (sfid-20160310_152618_150253_4465C485)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This is a first stab of implementing rtl8723bu_config_channel(). For
> now this will only do 20MHz channels.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

[...]

> +static void rtl8723bu_config_channel(struct ieee80211_hw *hw)
> +{
> +	struct rtl8xxxu_priv *priv = hw->priv;
> +	u32 val32, rsr;
> +	u8 val8, opmode, subchannel;
> +	u16 rf_mode_bw;
> +	bool ht = true;
> +	int sec_ch_above, channel;
> +	int i;
> +
> +	rf_mode_bw = rtl8xxxu_read16(priv, REG_WMAC_TRXPTCL_CTL);
> +	rf_mode_bw &= ~WMAC_TRXPTCL_CTL_BW_MASK;
> +	rsr = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
> +	channel = hw->conf.chandef.chan->hw_value;
> +
> +/* Hack */

Indentation.

-- 
Kalle Valo
