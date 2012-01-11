Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4630 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2AKNQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 08:16:06 -0500
Message-ID: <4F0D8B8F.1050105@qca.qualcomm.com> (sfid-20120111_141609_986410_2AD9D885)
Date: Wed, 11 Jan 2012 15:15:59 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai <tpachamu@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/4] ath6kl: Add uAPSD support in rx path.
References: <1326095135-1633-1-git-send-email-tpachamu@qca.qualcomm.com>
In-Reply-To: <1326095135-1633-1-git-send-email-tpachamu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 09:45 AM, Thirumalai wrote:

> +		ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, conn->aid, 0);
> +		if (is_apsdq_empty_at_start) {
> +			ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
> +					vif->fw_vif_idx,
> +					conn->aid, 0,
> +					WMI_AP_APSD_NO_DELIVERY_FRAMES);
> +		} else {
> +			ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
> +					vif->fw_vif_idx,
> +					conn->aid, 0, 0);
> +		}

To have only one call to ath6kl_wmi_set_apsd_bfrd_traf() you could add a
variable like this:

u32 flags;

....

if (is_apsdq_empty_at_start)
	flags = WMI_AP_APSD_NO_DELIVERY_FRAMES;
else
	flags = 0;

ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx, conn->aid, 0);
ath6kl_wmi_set_apsd_bfrd_traf(ar->wmi,
			vif->fw_vif_idx,
			conn->aid, 0, flags);

Kalle
