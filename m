Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1FCNoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:44:24 -0400
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org> (sfid-20110602_234730_485890_D6D54ECB)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	 <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
	 (sfid-20110602_234730_485890_D6D54ECB)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 15:44:21 +0200
Message-ID: <1307108661.3800.6.camel@jlt3.sipsolutions.net> (sfid-20110603_154426_976200_6EC47AA7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 18:46 -0300, Lauro Ramos Venancio wrote:

> + * @NFC_ATTR_TARGETS: array of targets (see enum nfc_target_attr)


> +static int nfc_genl_msg_put_target(struct sk_buff *msg,
> +				struct nfc_target *target)
> +{
> +	NLA_PUT_U32(msg, NFC_TARGET_ATTR_TARGET_INDEX, target->idx);
> +	NLA_PUT_U32(msg, NFC_TARGET_ATTR_SUPPORTED_PROTOCOLS,
> +				target->supported_protocols);
> +	NLA_PUT_U8(msg, NFC_TARGET_ATTR_SENS_RES, target->sens_res);
> +	NLA_PUT_U8(msg, NFC_TARGET_ATTR_SEL_RES, target->sel_res);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -EMSGSIZE;
> +}
> +
> +int nfc_genl_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
> +								int ntargets)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +	struct nlattr *targets_attr;
> +	int i;
> +
> +	pr_debug("%s\n", __func__);
> +
> +	dev->genl_data.poll_req_pid = 0;
> +
> +	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
> +				NFC_EVENT_TARGETS_FOUND);
> +	if (!hdr)
> +		goto free_msg;
> +
> +	NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
> +
> +	targets_attr = nla_nest_start(msg, NFC_ATTR_TARGETS);
> +
> +	for (i = 0; i < ntargets; i++) {
> +		struct nlattr *target = nla_nest_start(msg, i);
> +
> +		if (nfc_genl_msg_put_target(msg, &targets[i]))
> +			goto nla_put_failure;
> +
> +		nla_nest_end(msg, target);
> +	}
> +
> +	nla_nest_end(msg, targets_attr);
> +	genlmsg_end(msg, hdr);
> +
> +	return genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_ATOMIC);

This is almost certainly not a good idea.

Eventually, you will want to add more information about a target. I know
NFC is a pretty limited protocol, but I wouldn't want to make this
harder in the future than it must be. The way you're doing it, you're
currently limiting yourself to about 100 targets. Each new target
attribute that you might add in the future will reduce that number
significantly.

IMHO, the better way to structure this would be to create an event that
contains no information, and then allow a dump of the targets (with a
generation counter). That way, there are no such artificial limits due
to message sizes.


> +static int nfc_genl_dump_devices(struct sk_buff *skb,
> +                               struct netlink_callback *cb)

You should have a generation counter here so that applications getting a
dump can know whether their dump was a complete and consistent snapshot.
Otherwise, if devices are added or removed during the dump applications
will not be able to know that their dump wasn't right.

johannes

