Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50777 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbEIMKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 08:10:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH] wil6210: fix format specifier for dma_addr_t
References: <87fv7bvb9f.fsf@kamboji.qca.qualcomm.com>
	<1430840528-14998-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Sat, 09 May 2015 15:10:31 +0300
In-Reply-To: <1430840528-14998-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Tue, 5 May 2015 18:42:08 +0300")
Message-ID: <87a8xene88.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_141403_706560_486B2B6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Fix format specifier used for dma_addr_t, namely use %pad
> Debug print virtual address for the same buffer as well.
>
> It can be applied as:
> fixup! wil6210: Add pmc debug mechanism memory management
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

The right format for specifying the commit which this patch fixes is:

Fixes: dc16427bbe65 ("wil6210: Add pmc debug mechanism memory management")

See Documentatin/SubmittingPatches for more info.

But I see new warnings with this patch:

drivers/net/wireless/ath/wil6210/pmc.c:94:243: warning: format '%p' expects argument of type 'void *', but argument 6 has type 'dma_addr_t' [-Wformat]
drivers/net/wireless/ath/wil6210/pmc.c:94:478: warning: format '%p' expects argument of type 'void *', but argument 5 has type 'dma_addr_t' [-Wformat]

-- 
Kalle Valo
