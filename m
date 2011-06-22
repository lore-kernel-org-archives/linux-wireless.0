Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1FVHet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 03:34:49 -0400
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110620_195221_616961_4428A127)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
	 (sfid-20110620_195221_616961_4428A127)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 09:34:44 +0200
Message-ID: <1308728084.3883.9.camel@jlt3.sipsolutions.net> (sfid-20110622_093457_713194_96B09ADC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @NFC_ATTR_TARGET_SENS_RES: extra information for NFC-A targets
> + * @NFC_ATTR_TARGET_SEL_RES: extra information for NFC-A targets

Those descriptions aren't very useful to me, but hopefully if I knew
anything about NFC I'd understand :)

> +struct nfc_target {
> +	u32 idx;
> +	u32 supported_protocols;
> +	u16 sens_res;
> +	u8 sel_res;
> +};

There's no list_head here.

>  struct nfc_dev {
>  	unsigned idx;
> +	unsigned target_idx;
> +	struct nfc_target *targets;

And this looks like an array. Do you really want to do that? That means
lots of reallocations.

> +/**
> + * nfc_targets_found - inform that targets were found
> + *
> + * @dev: The nfc device that found the targets
> + * @targets: array of nfc targets found
> + * @ntargets: targets array size
> + *
> + * The device driver must call this function when one or many nfc targets
> + * are found. After calling this function, the device driver must stop
> + * polling for targets.
> + */
> +int nfc_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
> +							int n_targets)

I haven't looked at the API users, but do you really expect them to
build an array? That seems rather odd since I'd typically expect targets
to be discovered one by one, not en bloc.

> +	dev->targets_generation++;
> +
> +	kfree(dev->targets);
> +	dev->targets = kzalloc(n_targets * sizeof(struct nfc_target),
> +							GFP_ATOMIC);
> +	if (!dev->targets) {
> +		dev->n_targets = 0;
> +		spin_unlock_bh(&dev->targets_lock);
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(dev->targets, targets, n_targets * sizeof(struct nfc_target));
> +	dev->n_targets = n_targets;

If you really want to keep the array thing at least you should use
kmemdup(). I'd argue that the overhead won't be huge even if you don't,
since as you said yourself you don't expect tons of targets (and if you
do have tons of targets, this approach breaks down anyway).

I'd really consider going with a linked list.

> @@ -298,7 +353,10 @@ int nfc_register_device(struct nfc_dev *dev)
>  	rc = device_add(&dev->dev);
>  	mutex_unlock(&nfc_devlist_mutex);
>  
> -	return rc;
> +	if (rc < 0)
> +		return rc;
> +
> +	return nfc_genl_device_added(dev);

No rollback if nfc_genl_device_added() fails? Either you need to ignore
the error or roll back I think.

> +int nfc_genl_device_added(struct nfc_dev *dev)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	pr_debug("%s\n", __func__);
> +
> +	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;

I'd probably ignore the errors since any error just means userspace
wasn't notified, but it can still later look up the devices.

johannes

