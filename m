Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:36327 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYILUnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:43:15 -0400
Received: by hs-out-0708.google.com with SMTP id 4so412220hsl.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 13:43:14 -0700 (PDT)
Date: Fri, 12 Sep 2008 16:43:09 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] acer-wmi: Add rfkill support for wireless and bluetooth
	(v4)
Message-ID: <20080912164039.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080912_224320_664513_0B87037E)
References: <200808301206.56279.carlos@strangeworlds.co.uk> <200809071813.23730.carlos@strangeworlds.co.uk> <20080908032953.GA26459@khazad-dum.debian.net> <200809122044.27418.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809122044.27418.carlos@strangeworlds.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Carlos,

On Fri, Sep 12, 2008 at 08:44:26PM +0100, Carlos Corbacho wrote:
> +
> +static int acer_rfkill_register(struct device *dev, struct rfkill **rfkill_dev,
> +enum rfkill_type type, char *name, u32 cap)
> +{
> +	int err;
> +	u32 state;
> +	u32 *data;
> +
> +	*rfkill_dev = rfkill_allocate(dev, type);
> +	if (!*rfkill_dev)
> +		return -ENOMEM;
> +	(*rfkill_dev)->name = name;
> +	get_u32(&state, cap);
> +	(*rfkill_dev)->state = state ? RFKILL_STATE_UNBLOCKED :
> +		RFKILL_STATE_SOFT_BLOCKED;
> +	data = kzalloc(sizeof(u32), GFP_KERNEL);
> +	if (!data) {
> +		rfkill_free(*rfkill_dev);
> +		return -ENOMEM;
> +	}
> +	*data = cap;
> +	(*rfkill_dev)->data = data;
> +	(*rfkill_dev)->toggle_radio = acer_rfkill_set;
> +	(*rfkill_dev)->user_claim_unsupported = 1;
> +
> +	err = rfkill_register(*rfkill_dev);
> +	if (err) {
> +		kfree((*rfkill_dev)->data);
> +		rfkill_free(*rfkill_dev);
> +		return err;
> +	}
> +	return 0;
> +}
> +

Sorry if I am late to the party but this function is best to have
'struct rfkill *' return value and use ERR_PTR() to signal errors.

-- 
Dmitry
