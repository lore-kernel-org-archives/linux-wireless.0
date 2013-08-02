Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58728 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3HBHrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:47:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add SoC power save option to PCI features map
References: <1375348187-18216-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 2 Aug 2013 10:47:44 +0300
In-Reply-To: <1375348187-18216-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 1 Aug 2013 11:09:47 +0200")
Message-ID: <877gg4pm8v.fsf@kamboji.qca.qualcomm.com> (sfid-20130802_094756_278215_1E4096EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Unify the PCI options location.
>
> By default the SoC PS option is disabled to boost the
> performance and due to poor stability on early HW revisions.
> In future we can remove the module parameter and turn on/off
> the PS for given hardware.
>
> This change also makes the pci module parameter for SoC PS static.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

A minor nitpick:

> +	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
> +		ath10k_do_pci_wake(ar); /* Force AWAKE forever */

if (foo)
        /* comment */
        function_call();

-- 
Kalle Valo
