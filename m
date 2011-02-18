Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1BRL1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:27:36 -0500
Date: Fri, 18 Feb 2011 12:26:34 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/14] rtlwifi: rtl8192cu: Add routine trx
Message-ID: <20110218112633.GA2270@redhat.com>
References: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 17, 2011 at 03:19:05PM -0600, Larry Finger wrote:
> +static enum rtl_desc_qsel _rtl8192cu_mq_to_descq(struct ieee80211_hw *hw,
> +					 u16 fc, u16 mac80211_queue_index)
> +{
> +	enum rtl_desc_qsel qsel;
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +
> +	if (unlikely(ieee80211_is_beacon(fc))) {
> +		qsel = QSLT_BEACON;
> +		goto out;
> +	}
> +	if (ieee80211_is_mgmt(fc)) {
[snip]
> +	u16 fc = le16_to_cpu(hdr->frame_control);
> +	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
 
We have that bug on all over the code, ieee80211_is_* expect le16 value
whereas we pass cpu endian value. Driver is completely broken on that
respect, it will not work on big endian machines.

What should be done is use "sparse" (i.e. make C=1) and fix all
endian bugs. That will not assure driver will work on BE machines,
but at least we will fix obvious bugs.

Stanislaw
