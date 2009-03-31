Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:41993 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZCaSVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 14:21:08 -0400
Message-ID: <49D25EE4.6020202@lwfinger.net> (sfid-20090331_202113_226196_31F56FB2)
Date: Tue, 31 Mar 2009 13:20:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT v2] rfkill: rewrite
References: <1238349195.24972.5.camel@johannes.local>	 (sfid-20090329_195345_745378_2F2074B3) <1238451390.5970.59.camel@johannes.local>
In-Reply-To: <1238451390.5970.59.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:

-- snip --

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ wireless-testing/net/rfkill/core.c	2009-03-31 00:04:25.000000000 +0200
> @@ -0,0 +1,752 @@
> +/*

-- snip --

> +int __must_check rfkill_register(struct rfkill *rfkill)
> +{
> +	static unsigned long rfkill_no = 0;
> +	struct device *dev = &rfkill->dev;
> +	int error;
> +
> +	BUG_ON(!rfkill);
> +
> +	mutex_lock(&rfkill_global_mutex);
> +
> +	if (rfkill->registered) {
> +		error = -EALREADY;
> +		goto unlock;
> +	}
> +
> +	dev_set_name(dev, "rfkill%lu", rfkill_no);
> +	rfkill_no++;
> +
> +	if (!(rfkill_states_default_locked & BIT(rfkill->type))) {
> +		/* first of its kind */
> +		BUILD_BUG_ON(NUM_RFKILL_TYPES >
> +			sizeof(rfkill_states_default_locked) * 8);
> +		rfkill_states_default_locked |= BIT(rfkill->type);
> +		rfkill_global_states[rfkill->type].cur =
> +			rfkill_global_states[rfkill->type].def;
> +	}
> +
> +	/* XXX: schedule work to set default state */
> +
> +	list_add_tail(&rfkill->node, &rfkill_list);
> +
> +	error = device_add(dev);
> +	if (error)
> +		goto remove;
> +
> +	error = rfkill_led_trigger_register(rfkill);
> +	if (error)
> +		goto devdel;
> +
> +	rfkill->registered = true;
> +
> +	if (rfkill->ops->poll_hw_block) {
> +		INIT_DELAYED_WORK(&rfkill->poll_work, rfkill_poll);
> +		schedule_delayed_work(&rfkill->poll_work,
> +			round_jiffies_relative(POLL_INTERVAL));
> +	}
> +
> +	INIT_WORK(&rfkill->uevent_work, rfkill_uevent_work);
> +
> +	return 0;

The locking looks funny here. The normal return leaves the rfkill_global_mutex
locked. Did you mean "goto unlock" instead of "return 0"?

> +
> + devdel:
> +	device_del(&rfkill->dev);
> + remove:
> +	list_del_init(&rfkill->node);
> + unlock:
> + 	mutex_unlock(&rfkill_global_mutex);
> +	return error;
> +}

I was alerted to this problem when I was unable to shut down or reboot normally.
Those problems are fixed with the patch

Index: wireless-testing/net/rfkill/core.c
===================================================================
--- wireless-testing.orig/net/rfkill/core.c
+++ wireless-testing/net/rfkill/core.c
@@ -676,7 +676,7 @@ int __must_check rfkill_register(struct

 	INIT_WORK(&rfkill->uevent_work, rfkill_uevent_work);

-	return 0;
+	goto unlock;

  devdel:
        device_del(&rfkill->dev);


Larry
