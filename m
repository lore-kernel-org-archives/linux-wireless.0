Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56109 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaK0Ha0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 02:30:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
Date: Thu, 27 Nov 2014 09:30:09 +0200
In-Reply-To: <CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
	(Michal Kazior's message of "Wed, 26 Nov 2014 08:54:30 +0100")
Message-ID: <87ppc9umm6.fsf@kamboji.qca.qualcomm.com> (sfid-20141127_083032_175027_91ED4C67)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> 2. Have a dedicatd pci-specific structure:
>
>  struct ath10k_pci_supported_chip {
>    u16 dev_id;
>    u32 chip_id;
>  };
>
>  struct ath10k_pci_supported_chip ath10k_pci_supported_chips[] = {
>    { QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
>    // ...
>  };
>
> Probably the simplest and has least impact.

Another idea which is a variation of this:

In ath10k_core_register() we iterate through ath10k_hw_params_list and
make sure that the chip id is supported and if not, bail out. If the
chip id is found from the array continue the registration process like
in this patch. Basically this would be a whitelist check.

-- 
Kalle Valo
