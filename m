Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48379 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1FCUS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 16:18:29 -0400
Received: by eyx24 with SMTP id 24so794843eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 13:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307108661.3800.6.camel@jlt3.sipsolutions.net>
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	<1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
	<1307108661.3800.6.camel@jlt3.sipsolutions.net>
Date: Fri, 3 Jun 2011 17:18:26 -0300
Message-ID: <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com> (sfid-20110603_221831_180194_84D18426)
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

2011/6/3 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2011-06-02 at 18:46 -0300, Lauro Ramos Venancio wrote:
>
>> + * @NFC_ATTR_TARGETS: array of targets (see enum nfc_target_attr)
>
>
>> +static int nfc_genl_msg_put_target(struct sk_buff *msg,
>> +                             struct nfc_target *target)
>> +{
>> +     NLA_PUT_U32(msg, NFC_TARGET_ATTR_TARGET_INDEX, target->idx);
>> +     NLA_PUT_U32(msg, NFC_TARGET_ATTR_SUPPORTED_PROTOCOLS,
>> +                             target->supported_protocols);
>> +     NLA_PUT_U8(msg, NFC_TARGET_ATTR_SENS_RES, target->sens_res);
>> +     NLA_PUT_U8(msg, NFC_TARGET_ATTR_SEL_RES, target->sel_res);
>> +
>> +     return 0;
>> +
>> +nla_put_failure:
>> +     return -EMSGSIZE;
>> +}
>> +
>> +int nfc_genl_targets_found(struct nfc_dev *dev, struct nfc_target *targets,
>> +                                                             int ntargets)
>> +{
>> +     struct sk_buff *msg;
>> +     void *hdr;
>> +     struct nlattr *targets_attr;
>> +     int i;
>> +
>> +     pr_debug("%s\n", __func__);
>> +
>> +     dev->genl_data.poll_req_pid = 0;
>> +
>> +     msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
>> +     if (!msg)
>> +             return -ENOMEM;
>> +
>> +     hdr = genlmsg_put(msg, 0, 0, &nfc_genl_family, 0,
>> +                             NFC_EVENT_TARGETS_FOUND);
>> +     if (!hdr)
>> +             goto free_msg;
>> +
>> +     NLA_PUT_U32(msg, NFC_ATTR_DEVICE_INDEX, dev->idx);
>> +
>> +     targets_attr = nla_nest_start(msg, NFC_ATTR_TARGETS);
>> +
>> +     for (i = 0; i < ntargets; i++) {
>> +             struct nlattr *target = nla_nest_start(msg, i);
>> +
>> +             if (nfc_genl_msg_put_target(msg, &targets[i]))
>> +                     goto nla_put_failure;
>> +
>> +             nla_nest_end(msg, target);
>> +     }
>> +
>> +     nla_nest_end(msg, targets_attr);
>> +     genlmsg_end(msg, hdr);
>> +
>> +     return genlmsg_multicast(msg, 0, nfc_genl_event_mcgrp.id, GFP_ATOMIC);
>
> This is almost certainly not a good idea.
>
> Eventually, you will want to add more information about a target. I know
> NFC is a pretty limited protocol, but I wouldn't want to make this
> harder in the future than it must be. The way you're doing it, you're
> currently limiting yourself to about 100 targets. Each new target
> attribute that you might add in the future will reduce that number
> significantly.

Actually, we don't expect more than a couple of targets because of NFC
short range.
I agree that this can be a problem if we start supporting vicinity cards.

> IMHO, the better way to structure this would be to create an event that
> contains no information, and then allow a dump of the targets (with a
> generation counter). That way, there are no such artificial limits due
> to message sizes.

I agree that this is a better solution. But I think we don't need a
generation counter because only a new polling operation (start_poll
call) can change the targets list (i.e. there is no passive polling).

>> +static int nfc_genl_dump_devices(struct sk_buff *skb,
>> +                               struct netlink_callback *cb)
>
> You should have a generation counter here so that applications getting a
> dump can know whether their dump was a complete and consistent snapshot.
> Otherwise, if devices are added or removed during the dump applications
> will not be able to know that their dump wasn't right.
>

We don't need a generation counter here because we have the events
NFC_EVENT_DEVICE_ADDED and NFC_EVENT_DEVICE_REMOVED. So, it is
possible to keep the device list consistency listening for these
events.


Lauro
