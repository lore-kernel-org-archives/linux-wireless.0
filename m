Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65044 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab1FVUDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:03:08 -0400
Received: by vws1 with SMTP id 1so849745vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 13:03:08 -0700 (PDT)
Date: Wed, 22 Jun 2011 17:03:27 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Eliad Peller <eliad@wizery.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
Message-ID: <20110622200326.GC2583@joana> (sfid-20110622_220312_764272_81364465)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
 <20110621220510.GG2628@joana>
 <BANLkTikdLv6JuNRd1qL-_Jje_4GFDT4tOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTikdLv6JuNRd1qL-_Jje_4GFDT4tOQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

* Eliad Peller <eliad@wizery.com> [2011-06-22 01:15:42 +0300]:

> On Wed, Jun 22, 2011 at 1:05 AM, Gustavo F. Padovan
> <padovan@profusion.mobi> wrote:
> >> +static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
> >> +                                     struct netlink_callback *cb, int flags)
> >> +{
> >> +     void *hdr;
> >> +
> >> +     pr_debug("%s\n", __func__);
> >> +
> >> +     hdr = genlmsg_put(msg, NETLINK_CB(cb->skb).pid, cb->nlh->nlmsg_seq,
> >> +                             &nfc_genl_family, flags, NFC_CMD_GET_TARGET);
> >> +     if (!hdr)
> >> +             return -EMSGSIZE;
> >> +
> >> +     genl_dump_check_consistent(cb, hdr, &nfc_genl_family);
> >> +
> >> +     NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target->idx);
> >> +     NLA_PUT_U32(msg, NFC_ATTR_PROTOCOLS,
> >> +                             target->supported_protocols);
> >> +     NLA_PUT_U16(msg, NFC_ATTR_TARGET_SENS_RES, target->sens_res);
> >> +     NLA_PUT_U8(msg, NFC_ATTR_TARGET_SEL_RES, target->sel_res);
> >> +
> >> +     return genlmsg_end(msg, hdr);
> >> +
> >> +nla_put_failure:
> >
> > There is no use for this macro in all function that have a label with this
> > name.
> 
> the NLA_PUT_* macros use this label:
> 
> #define NLA_PUT(skb, attrtype, attrlen, data) \
> 	do { \
> 		if (unlikely(nla_put(skb, attrtype, attrlen, data) < 0)) \
> 			goto nla_put_failure; \
> 	} while(0)

Nice to know, I'm not a netlink expert. Thanks.

	Gustavo
