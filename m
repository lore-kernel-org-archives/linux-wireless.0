Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41253 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYHaNgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2008 09:36:38 -0400
Date: Sun, 31 Aug 2008 10:36:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] acer-wmi: Add rfkill support for wireless and bluetooth
	(v2)
Message-ID: <20080831133631.GA9794@khazad-dum.debian.net> (sfid-20080831_153650_082825_41168787)
References: <200808301206.56279.carlos@strangeworlds.co.uk> <20080830140730.GB12246@khazad-dum.debian.net> <200808301654.03329.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808301654.03329.carlos@strangeworlds.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 30 Aug 2008, Carlos Corbacho wrote:
> +static void device##_rfkill_update(struct work_struct *ignored) \
> +{ \
> +	u32 state; \
> +	acpi_status status; \
> +	status = get_u32(&state, cap); \
> +	\
> +	if (ACPI_SUCCESS(status)) \
> +		rfkill_force_state(device##_rfkill, state); \
> +	queue_delayed_work(rfkill_workqueue, &device##_rfkill_work, \
> +		round_jiffies_relative(HZ)); \
> +}

You are still doing state = (int);  rfkill_force_state(foo, state);

Please do a rfkill_force_state(foo, state ? RFKILL_STATE_UNBLOCKED :
					RFKILL_STATE_SOFT_BLOCKED);

or whatever is correct for what the values of (state) mean.

> +	err = rfkill_register(wireless_rfkill);
> +	if (err)
> +		return err;

You have to manually dealocate wireless_rfkill on the error path here using
rfkill_free (and maybe set it to NULL to avoid double-free or somesuch), or
you will leak memory.

I heavily suggest re-reading the kernel doc info for every rfkill function
you're using.  They're well described and documented, including caveats such
as the one above.

> +	if (!rfkill_workqueue)
> +		return -ENOMEM;

Needs to dealocate the stuff you alocated, unless the caller will do so.

> +	destroy_workqueue(rfkill_workqueue);
> +	rfkill_unregister(wireless_rfkill);
> +	rfkill_free(wireless_rfkill);

I know it is somewhat surprising, but you must never rfkill_free something
you have called rfkill_unregister on.  You use rfkill_free only to get rid
of memory when rfkill_register fails.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
