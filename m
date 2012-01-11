Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36739 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2AKM1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 07:27:42 -0500
Message-ID: <4F0D8036.8030306@qca.qualcomm.com> (sfid-20120111_132745_819767_6500C1AC)
Date: Wed, 11 Jan 2012 14:27:34 +0200
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

> +#define WMI_DATA_HDR_TRIGGER_MASK      0x1
> +#define WMI_DATA_HDR_TRIGGER_SHIFT     4
> +
> +#define WMI_DATA_HDR_EOSP_MASK      WMI_DATA_HDR_TRIGGER_MASK
> +#define WMI_DATA_HDR_EOSP_SHIFT     WMI_DATA_HDR_TRIGGER_SHIFT

This looks a bit odd, I can't see why you want to use trigger
definitions for eosp. Even if the values are same I don't see the
benefit for using trigger values for eosp. Is there a particular reason
for this?

Kalle
