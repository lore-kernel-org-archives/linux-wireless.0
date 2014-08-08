Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50463 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaHHJpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:45:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [RFC 3/3] ath10k: make target endianess more explicit
References: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com>
	<1407489735-28091-4-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 12:45:12 +0300
In-Reply-To: <1407489735-28091-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 8 Aug 2014 11:22:15 +0200")
Message-ID: <87lhqzz55j.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_114524_526797_3423DE12)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some copy engine structures are target specific
> and are uploaded to the device during
> init/configuration.
>
> This also cleans up a bit diag_mem_read/write
> implicit byteswap mess leaving only
> diag_access_read/write with an implicit endianess
> byteswap.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -567,8 +562,17 @@ static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
>  				       u32 *data)
>  {
>  	/* Assume range doesn't cross this boundary */
> -	if (address >= DRAM_BASE_ADDRESS)
> -		return ath10k_pci_diag_read_mem(ar, address, data, sizeof(u32));
> +	if (address >= DRAM_BASE_ADDRESS) {
> +		__le32 val;
> +		int ret;

For simplicity I would prefer to have variable declaration in the
beginning of the function.

-- 
Kalle Valo
