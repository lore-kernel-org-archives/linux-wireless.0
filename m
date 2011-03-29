Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42388 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1C2Kpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 06:45:49 -0400
Message-ID: <4D91B856.8040302@suse.cz>
Date: Tue, 29 Mar 2011 12:45:42 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	rmk+kernel@arm.linux.org.uk, devel@linuxdriverproject.org,
	gregkh@suse.de, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1301391619-4499-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2011 11:40 AM, Arend van Spriel wrote:
> --- /dev/null
> +++ b/drivers/brcmaxi/axi.c
> @@ -0,0 +1,786 @@
...
> +/* resetctrl */
> +#define	AIRC_RESET		1
> +
> +/* definition for specifying padding fields */
> +#define	_PADLINE(line)	pad ## line
> +#define	_XSTR(line)	_PADLINE(line)
> +#define	PAD		_XSTR(__LINE__)
> +
> +/*
> + * struct aidmp - device management plugin "wrapper" registers.
> + */
> +struct aidmp {

This looks like it should be __packed__.

> +	u32 oobselina30;	/* 0x000 */
> +	u32 oobselina74;	/* 0x004 */
> +	u32 PAD[6];
...
> +};
...
> +struct axi_local *axi_create(u32 priv_len)
> +{
> +	struct axi_local *inst;
> +	int size = ALIGN(sizeof(*inst), 4) + priv_len;
> +
> +	inst = kzalloc(size, GFP_ATOMIC);

Hmm, ATOMIC without checking the retval. This is prepared for its first
crash under a high memory pressure.

> +	try_module_get(THIS_MODULE);
> +
> +	return inst;
> +}
> +struct axi_instance *axi_open(void *regs, u32 erombase, u32 priv_len)
> +{
> +	struct axi_local *inst = axi_create(priv_len);
> +
> +	/* fill public fields */
> +	inst->pub.regs = regs;
> +	inst->pub.priv = (char *)inst + ALIGN(sizeof(*inst), 4);
> +
> +	inst->enum_rom_ptr = ioremap_nocache((unsigned long)erombase,
> +					     AXI_CORE_SIZE);

Check retval.

> +	return &inst->pub;
> +}
...

regards,
-- 
js
suse labs
