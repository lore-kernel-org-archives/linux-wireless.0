Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdLDPBQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 10:01:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
        <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
Date: Mon, 04 Dec 2017 17:01:12 +0200
In-Reply-To: <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Mon, 13 Nov 2017 13:28:15 +0300")
Message-ID: <871skalepz.fsf@purkki.adurom.net> (sfid-20171204_160131_206241_7976FE5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Vasily Ulyanov <vulyanov@quantenna.com>
>
> This allows a running AP to blacklist STAs by their MAC addresses
> respecting the configured policy (either accept or deny unless listed).
> It can be setup on .start_ap or with .set_mac_acl commands.
>
> Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>

[...]

> @@ -918,6 +933,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
>  	wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
>  	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
>  	wiphy->max_remain_on_channel_duration = 5000;
> +	wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
>  
>  	wiphy->iface_combinations = iface_comb;
>  	wiphy->n_iface_combinations = 1;
> @@ -932,6 +948,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
>  			WIPHY_FLAG_AP_UAPSD |
>  			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
>  
> +	if (wiphy->max_acl_mac_addrs > 0)
> +		wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;

Conditonally enabling WIPHY_FLAG_HAVE_AP_SME looks somewhat suspicious
to me and from a quick search I don't see any other driver doing
something similar. Can you explain why AP_SME is related to MAC ACL?

-- 
Kalle Valo
