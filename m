Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0053.outbound.protection.outlook.com ([104.47.34.53]:52734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751317AbdH3OCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 10:02:23 -0400
Date: Wed, 30 Aug 2017 17:02:10 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 06/27] qtnfmac: pass full channel definition to device on
 start_ap command
Message-ID: <20170830140209.r3gbg22rlvzziklf@bars> (sfid-20170830_160227_153997_31E5000B)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-7-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-7-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	if (s->ssid && s->ssid_len > 0 && s->ssid_len <= IEEE80211_MAX_SSID_LEN)
> +		qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, s->ssid,
> +					 s->ssid_len);
> +
> +	if (cfg80211_chandef_valid(&s->chandef)) {
> +		struct qlink_tlv_chandef *chtlv =
> +			(struct qlink_tlv_chandef *)skb_put(cmd_skb,
> +							    sizeof(*chtlv));
> +
> +		chtlv->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANDEF);
> +		chtlv->hdr.len = sizeof(*chtlv) - sizeof(chtlv->hdr);

It looks like cpu_to_le16 is needed here as well.

> +		qlink_chandef_cfg2q(&s->chandef, &chtlv->chan);
> +	}
> +
