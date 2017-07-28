Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdG1OjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:39:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: correct IE parse during association
References: <1500263187-1167-1-git-send-email-huxinming820@gmail.com>
Date: Fri, 28 Jul 2017 17:39:17 +0300
In-Reply-To: <1500263187-1167-1-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Mon, 17 Jul 2017 03:46:27 +0000")
Message-ID: <87mv7owrqi.fsf@purkki.adurom.net> (sfid-20170728_163927_432798_1D357884)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> It is observed that some IEs get missed during association.
> This patch correct the old IE parse code. sme->ie will be
> store as wpa ie, wps ie, wapi ie and gen ie accordingly.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

[...]

> +		} else {
> +			if (pvendor_ie->element_id ==
> +			    WLAN_EID_VENDOR_SPECIFIC) {
> +				/* Test to see if it is a WPA IE,
> +				 * if not, then it is a gen IE
> +				 */
> +				if (!memcmp(pvendor_ie->oui, wpa_oui,
> +					    sizeof(wpa_oui))) {
> +					/* IE is a WPA/WPA2 IE so call
> +					 * set_wpa function
> +					 */
> +					mwifiex_set_wpa_ie(priv,
> +							   (u8 *)pvendor_ie,
> +							   cur_ie_len);

The indentation is getting ugly here. A helper function or similar would
really make this more readable.


[...]

> +NEXT_IE:

Goto labels in lower case, please.

-- 
Kalle Valo
