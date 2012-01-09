Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2AILkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 06:40:32 -0500
Message-ID: <4F0AD21F.8000204@qca.qualcomm.com> (sfid-20120109_124035_454725_192A06C3)
Date: Mon, 9 Jan 2012 13:40:15 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai <tpachamu@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/4] ath6kl: Introduce new queue for uAPSD.
References: <1326095120-1603-1-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326095120-1603-1-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 09:45 AM, Thirumalai wrote:
> Add apsd_info in necessary places to indicate which
> AC's uAPSD is enabled.
> 
> A bit is added in the wmi header (bit 4 of info3)
> to specify uapsd trigger in rx direction (target to host)
> and end of service period in tx direction (host to target)
> 
> Signed-off-by: Thirumalai <tpachamu@qca.qualcomm.com>

[...]

> +static inline void wmi_data_hdr_set_more_bit(struct wmi_data_hdr *dhdr)
> +{
> +	dhdr->info |= (WMI_DATA_HDR_MORE_MASK << WMI_DATA_HDR_MORE_SHIFT);
> +}
> +
> +static inline void wmi_data_hdr_set_eosp_bit(struct wmi_data_hdr *dhdr)
> +{
> +	dhdr->info3 |= (WMI_DATA_HDR_EOSP_MASK << WMI_DATA_HDR_EOSP_SHIFT);
> +}

I only see one caller for these functions so it's better to copy the
code to the caller directly and not have any extra functions.

Kalle
