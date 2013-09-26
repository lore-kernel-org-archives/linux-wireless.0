Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7246 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3IZIMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 04:12:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/13] ath10k: introduce dynamic WMI structures
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 11:12:12 +0300
In-Reply-To: <1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 25 Sep 2013 11:37:59 +0200")
Message-ID: <87wqm4rogz.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_101226_101422_8899404F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This is the initial framework to implement dynamic
> WMI API in order to support new firmware (from so
> called 10.X branch)
>
> The realization is to have a static WMI cmd map for
> each of the firmwares, registered upom wmi init.
>
> This patch creates such map for MAIN FW, updates
> wmi_cmd_send() calls to take as a parameter
> the map value instead of direct WMI enum.
>
> As soon as complete 10.X API will be on place,
> we will introduce the FW IE mechanics to dynamicaly
> identify which FW is being used and based on that
> we will use correct map, API, structures, etc.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

> @@ -268,6 +269,9 @@ enum ath10k_fw_features {
>  	/* wmi_mgmt_rx_hdr contains extra RSSI information */
>  	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
>  
> +	/* firmware from 10X branch */
> +	ATH10K_FW_FEATURE_10X = 1,
> +

As this feature bit seems to be only used related the WMI code, I think
it's better to rename it to ATH10K_FW_FEATURE_WMI_10X. Better to keep
the scope of feature bits as small as practically possible. That way
it's easier to disable features when the firmware interface changes.

-- 
Kalle Valo
