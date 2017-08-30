Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0077.outbound.protection.outlook.com ([104.47.38.77]:48736
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751302AbdH3MHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:07:32 -0400
Date: Wed, 30 Aug 2017 15:07:19 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 21/27] qtnfmac: extend "IE set" TLV to include frame type
 info
Message-ID: <20170830120635.62m2eupefizpgcto@bars> (sfid-20170830_140736_526721_E05C8DB3)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-22-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-22-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -		if (tlv_full_len > payload_len) {
> -			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
> -				mac->macid, vif->vifid, tlv_type,
> -				tlv_value_len);
> +		if (tlv_full_len > payload_len)
>  			return -EINVAL;
> -		}

Why drop this sanity check ?

>  		if (tlv_type == QTN_TLV_ID_IE_SET) {
> -			sinfo.assoc_req_ies = tlv->val;
> -			sinfo.assoc_req_ies_len = tlv_value_len;
> +			const struct qlink_tlv_ie_set *ie_set;
> +			unsigned int ie_len;
> +
> +			if (payload_len < sizeof(*ie_set))
> +				return -EINVAL;
> +
> +			ie_set = (const struct qlink_tlv_ie_set *)tlv;
> +			ie_len = tlv_value_len -
> +				(sizeof(*ie_set) - sizeof(ie_set->hdr));
> +
> +			if (ie_set->type == QLINK_IE_SET_ASSOC_REQ && ie_len) {
> +				sinfo.assoc_req_ies = ie_set->ie_data;
> +				sinfo.assoc_req_ies_len = ie_len;
> +			}
>  		}

Does it make sense to keep QTN_TLV_ID_IE_SET here at all ?
Maybe replace it completely by qlink_tlv_ie_set with
QLINK_IE_SET_ASSOC_REQ type ? Also see the comment below
for the similar snippet in qtnf_event_handle_scan_results.

...

> -		if (tlv_full_len > payload_len) {
> -			pr_warn("VIF%u.%u: malformed TLV 0x%.2X; LEN: %u\n",
> -				vif->mac->macid, vif->vifid, tlv_type,
> -				tlv_value_len);
> +		if (tlv_full_len > payload_len)
>  			return -EINVAL;
> -		}

ditto

...

>  		if (tlv_type == QTN_TLV_ID_IE_SET) {
> -			ies = tlv->val;
> -			ies_len = tlv_value_len;
> +			const struct qlink_tlv_ie_set *ie_set;
> +			unsigned int ie_len;
> +
> +			if (payload_len < sizeof(*ie_set))
> +				return -EINVAL;
> +
> +			ie_set = (const struct qlink_tlv_ie_set *)tlv;
> +			ie_len = tlv_value_len -
> +				(sizeof(*ie_set) - sizeof(ie_set->hdr));
> +
> +			if (ie_len) {
> +				ies = ie_set->ie_data;
> +				ies_len = ie_len;
> +			}
>  		}
>  	}

Two points here. First, it looks like there is a problem here inherited
from the existing implementation. We go through payload, but in fact we
pass to cfg80211_inform_bss only the last QTN_TLV_ID_IE_SET element.
Second, it looks like QTN_TLV_ID_IE_SET here should be treated in
the same way as in qtnf_event_handle_sta_assoc, to avoid confusion.
In other words, either we use only QTN_TLV_ID_IE_SET in both cases,
or switch to specific qlink_tlv_ie_set elements.

Thoughts ? Comments ?

Regards,
Sergey
