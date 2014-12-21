Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:59019 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566AbaLURYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 12:24:05 -0500
Message-ID: <1419182642.4200.5.camel@perches.com> (sfid-20141221_182410_596749_9F21202B)
Subject: Re: [PATCH 01/10] brcmfmac: Fix incorrect casting of 64 bit
 physical address.
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Date: Sun, 21 Dec 2014 09:24:02 -0800
In-Reply-To: <1419162233-19492-2-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
	 <1419162233-19492-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-21 at 12:43 +0100, Arend van Spriel wrote:
> The physical addresses being used by pcie and msgbuf were using
> a cast to long, which incorrectly caused it to limit the address
> to 32bit. Now explicit u64 is used where needed.

Maybe these should be phys_addr_t instead?

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
[]
> @@ -583,7 +583,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
>  	u32 flowid;
>  	void *dma_buf;
>  	u32 dma_sz;
> -	long long address;
> +	u64 address;


