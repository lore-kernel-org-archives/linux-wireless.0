Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57863 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbcDEMwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:52:03 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH] ath10k: remove MSI range support
Date: Tue, 5 Apr 2016 12:51:52 +0000
Message-ID: <87oa9ob4m0.fsf@kamboji.qca.qualcomm.com> (sfid-20160405_145215_704436_A7FA6CAC)
References: <1459426522-25925-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1459426522-25925-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 31 Mar 2016 17:45:22 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> MSI-X is never well-tested, might contain bugs and generally isn't
> really all that useful to maintain. Also ath10k is mainly used with
> shared/singly-MSI interrupt systems. Hence removing MSI range support.
> This change will be useful for further cleanup in copy engine lock
> and to add NAPI support.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> @@ -171,14 +168,10 @@ struct ath10k_pci {
>  	void __iomem *mem;
>  	size_t mem_len;
>  
> -	/*
> -	 * Number of MSI interrupts granted, 0 --> using legacy PCI line
> -	 * interrupts.
> -	 */
> -	int num_msi_intrs;
> +	/* Operating interrupt mode */
> +	u8 oper_irq_mode;

Shouldn't this be enum ath10k_pci_irq_mode?

-- 
Kalle Valo