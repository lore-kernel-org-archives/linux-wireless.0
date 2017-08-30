Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:27114
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751318AbdH3MfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:35:19 -0400
Date: Wed, 30 Aug 2017 15:35:06 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 23/27] qtnfmac: convert "Append IEs" command to
 QTN_TLV_ID_IE_SET usage
Message-ID: <20170830123506.ijw5kiku6bhvpuvf@bars> (sfid-20170830_143524_350197_C0D15790)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-24-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-24-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
> +	if (len > QTNF_MAX_CMD_BUF_SIZE) {
>  		pr_warn("VIF%u.%u: %u frame is too big: %zu\n", vif->mac->macid,
>  			vif->vifid, frame_type, len);
>  		return -E2BIG;

It looks like we need the following check here:
	sizeof(struct qlink_tlv_ie_set) + len > QTNF_MAX_CMD_BUF_SIZE
