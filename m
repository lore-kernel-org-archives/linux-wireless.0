Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44434 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1FUWPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 18:15:44 -0400
Received: by ywe9 with SMTP id 9so99367ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 15:15:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110621220510.GG2628@joana>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
	<1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
	<20110621220510.GG2628@joana>
Date: Wed, 22 Jun 2011 01:15:42 +0300
Message-ID: <BANLkTikdLv6JuNRd1qL-_Jje_4GFDT4tOQ@mail.gmail.com> (sfid-20110622_001547_668787_15DF2817)
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
From: Eliad Peller <eliad@wizery.com>
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 1:05 AM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
>> +static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
>> +                                     struct netlink_callback *cb, int flags)
>> +{
>> +     void *hdr;
>> +
>> +     pr_debug("%s\n", __func__);
>> +
>> +     hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq,
>> +                             &nfc_genl_family, flags, NFC_CMD_GET_TARGET);
>> +     if (!hdr)
>> +             return -EMSGSIZE;
>> +
>> +     genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
>> +
>> +     NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target->idx);
>> +     NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS,
>> +                             target->supported_protocols);
>> +     NLA_PUT_U16(msg, NFC_ATTR_TARGET_SENS_RES, target->sens_res);
>> +     NLA_PUT_U8(msg, NFC_ATTR_TARGET_SEL_RES, target->sel_res);
>> +
>> +     return genlmsg_end(msg, hdr);
>> +
>> +nla_put_failure:
>
> There is no use for this macro in all function that have a label with this
> name.

the NLA_PUT_* macros use this label:

#define NLA_PUT(skb, attrtype, attrlen, data) \
	do { \
		if (unlikely(nla_put(skb, attrtype, attrlen, data) < 0)) \
			goto nla_put_failure; \
	} while(0)

Eliad.
