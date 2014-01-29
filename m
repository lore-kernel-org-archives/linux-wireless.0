Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50194 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaA2NOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:14:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: configure access category for arp
References: <1390999696-8895-1-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 29 Jan 2014 15:14:12 +0200
In-Reply-To: <1390999696-8895-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Wed, 29 Jan 2014 13:48:16 +0100")
Message-ID: <87ppnbdj6j.fsf@kamboji.qca.qualcomm.com> (sfid-20140129_141421_325205_B02AC843)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> ARP frames exchange does not work properly for UAPSD enabled AP.
> ARP requests which arrives with access category 0 are processed
> by network stack and send back with access category 0. FW changes
> access category to 6. This is causing problems when UAPSD associated
> STA is sleeping after has sent ARP request. Configure ARP access
> category in FW to best effort (0) solves this problem. ARP frames
> will be send with access category 0.
>
> Simplify arp ac override functionality by removing redundant entry in
> pdev param maping table. There should be only one entry in pdev param
> map but enum has different name for different FW.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

I had a conflict when I applied this to ath-next-test. Please check that
I didn't break anything:

https://github.com/kvalo/ath/commit/2e006642b3aad6a5fb91f9e560a2bbcdf74aa049

> +	ret = ath10k_wmi_pdev_set_param(ar,
> +					ar->wmi.pdev_param->arp_ac_override, 0);
> +	if (ret) {
> +		ath10k_warn("could not init WMI_PDEV_PARAM_ARP_AC_OVERRIDE (%d)\n",
> +			    ret);

I also modified this warning message to follow the style used elsewhere
in the driver.

-- 
Kalle Valo
