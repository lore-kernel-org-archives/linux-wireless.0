Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3933 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1GME3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 00:29:23 -0400
Subject: Re: [PATCH 07/24] ath6kl: add debug.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713013405.8517.51546.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013405.8517.51546.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:29:22 -0700
Message-ID: <1310531362.1143.28.camel@Joe-Laptop> (sfid-20110713_062925_441933_A54057CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:34 +0300, Kalle Valo wrote: 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
[] 
> +int ath6kl_printk(const char *level, const char *fmt, ...)

Looks familiar.

> +#ifdef CONFIG_ATH6KL_DEBUG
> +void ath6kl_dump_registers(struct ath6kl_device *dev,
> +			   struct ath6kl_irq_proc_registers *irq_proc_reg,
> +			   struct ath6kl_irqenable_reg *irq_enable_reg)
> +{
> +
> +	ath6kl_dbg(ATH6KL_DBG_ANY, ("<------- Register Table -------->\n"));
> +
> +	if (irq_proc_reg != NULL) {
> +		ath6kl_dbg(ATH6KL_DBG_ANY,
> +			"Host Int status:           0x%x\n",
> +			irq_proc_reg->host_int_status);
> + ath6kl_dbg(ATH6KL_DBG_ANY,
> + "CPU Int status:            0x%x\n",
> + irq_proc_reg->cpu_int_status);

Some text could be saved by using:

		ath6kl_dbg(ATH6KL_DBG_ANY, "%-26x 0x%x\n",
			   "Host Int status:", inq_proc_reg->host_int_status);
		ath6kl_dbg(ATH6KL_DBG_ANY, "%-26x 0x%x\n"
			   "CPU Int status:", irq_proc_reg->cpu_int_status);
etc.



