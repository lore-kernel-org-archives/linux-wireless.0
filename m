Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E792DC43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 19:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C016220840
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 19:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfCGTiA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 14:38:00 -0500
Received: from postout1.mail.lrz.de ([129.187.255.137]:50784 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfCGTiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 14:38:00 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2019 14:37:57 EST
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 44Fghw5SVGzycg;
        Thu,  7 Mar 2019 20:30:56 +0100 (CET)
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id nXS6D6YloggW; Thu,  7 Mar 2019 20:30:56 +0100 (CET)
Received: from mission-control (unknown [207.180.219.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by postout1.mail.lrz.de (Postfix) with ESMTPSA id 44Fghv1tzczycf;
        Thu,  7 Mar 2019 20:30:55 +0100 (CET)
Date:   Thu, 7 Mar 2019 20:30:45 +0100
From:   ga58taw@mytum.de
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Julius Niedworok <julius.n@gmx.net>,
        linux-wireless@vger.kernel.org, ga58taw@mytum.de, david@redhat.com,
        nc@net.in.tum.de, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
Message-ID: <20190307193045.a7awwn6mycloccq5@mission-control>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
 <20190306200206.60916-1-julius.n@gmx.net>
 <87k1hazo6r.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k1hazo6r.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 07, 2019 at 05:42:04PM +0200, Kalle Valo wrote:
> > +   len = scnprintf(buf, sizeof(buf), "%d\n", (int)local->force_tx_status);
>
> I wonder about the cast, is it guaranteed that a bool is always of the
> same size as an int?

Why is this a problem? If a bool is smaller than an int, the compiler
emits code that will prepend the value of force_tx_status with zeros. If
it is larger than an int the compiler emits code that will truncate
force_tx_status to sizeof(int) bytes. So it doesn't matter how large bool
and/or int are, the code always prints '0' or '1' depending on the value
of force_tx_status.

> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -2463,6 +2463,11 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
> >     if (IS_ERR(sta))
> >             sta = NULL;
> >
> > +#ifdef CONFIG_MAC80211_DEBUGFS
> > +           if (local->force_tx_status)
> > +                   info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
> > +#endif
> > +
> >     /* convert Ethernet header to proper 802.11 header (based on
> >      * operation mode) */
> >     ethertype = (skb->data[12] << 8) | skb->data[13];
> > @@ -3468,6 +3473,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
> >                   (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
> >     info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT;
> >
> > +#ifdef CONFIG_MAC80211_DEBUGFS
> > +           if (local->force_tx_status)
> > +                   info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
> > +#endif
>
> IMHO the ifdefs look pointless just to save four bytes. I would move
> force_tx_status outside of ifdef in the struct so that the actual code
> doesn't have ugly ifdefs.

I don't think ifdefs are ugly in this case. They clearly indicate that the
code belongs to the debugfs implementation of mac80211. In addition, when
we remove the ifdefs, code that only belongs to the debugfs implementation
of mac80211 is always included in the kernel (even when the config
option is turned off!) which, I think, is much more ugly than the ifdefs.

Thanks for your comments and ideas.

Charlie
