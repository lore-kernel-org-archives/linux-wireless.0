Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755263AbdKJB02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 20:26:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH V2 1/9] qtnfmac: use per-band HT/VHT info from wireless device
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
        <20171031010455.27772-2-igor.mitsyanko.os@quantenna.com>
Date: Fri, 10 Nov 2017 03:26:24 +0200
In-Reply-To: <20171031010455.27772-2-igor.mitsyanko.os@quantenna.com> (igor
        mitsyanko os's message of "Mon, 30 Oct 2017 18:04:47 -0700")
Message-ID: <87mv3uncu7.fsf@purkki.adurom.net> (sfid-20171110_022632_625911_7633E490)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

igor.mitsyanko.os@quantenna.com writes:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>
> HT/VHT capabilities must be reported per each band supported by a radio,
> not for all bands on a radio. Furthermore, driver better not assume
> any capabilities and just use whetever is reported by device itself.
>
> To support this, convert "get channels" command into "get band info"
> command. Difference is that it may also carry HT/VHT capabilities along
> with channels information.
>
> While at it, also add "num_bitrates" field to "get band info" command,
> for future use.
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

[...]

> @@ -1241,13 +1273,32 @@ qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
>  				 chan->hw_value, chan->flags, chan->max_power,
>  				 chan->max_reg_power);
>  			break;
> +		case WLAN_EID_HT_CAPABILITY:
> +			if (unlikely(tlv_dlen !=
> +				     sizeof(struct ieee80211_ht_cap))) {
> +				pr_err("bad HTCAP TLV len %zu\n", tlv_dlen);
> +				goto error_ret;
> +			}
> +
> +			qtnf_cmd_resp_band_fill_htcap(tlv->val, &band->ht_cap);
> +			break;
> +		case WLAN_EID_VHT_CAPABILITY:
> +			if (unlikely(tlv_dlen !=
> +				     sizeof(struct ieee80211_vht_cap))) {
> +				pr_err("bad VHTCAP TLV len %zu\n", tlv_dlen);
> +				goto error_ret;
> +			}
> +
> +			qtnf_cmd_resp_band_fill_vhtcap(tlv->val,
> +						       &band->vht_cap);
> +			break;

I'm having a hard time to believe that this in hotpath so the use of
unlikely() is not really making any sense to me. No need to resend
because of this, just looks strange and makes the code harder to read.

-- 
Kalle Valo
