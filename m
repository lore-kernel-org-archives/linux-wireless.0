Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:39184
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752464AbdLEQ1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:27:18 -0500
Date: Tue, 5 Dec 2017 19:27:02 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 03/10] qtnfmac: add support for radar detection and CAC
Message-ID: <20171205162702.5dromsl3xtf3lgkw@bars> (sfid-20171205_172731_748038_80110512)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-4-sergey.matyukevich.os@quantenna.com>
 <87a7yylf9e.fsf@purkki.adurom.net>
 <87609mlf4s.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87609mlf4s.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> +int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
> >> +                   const struct cfg80211_chan_def *chdef,
> >> +                   u32 cac_time_ms)
> >> +{
> >> +    struct qtnf_bus *bus = vif->mac->bus;
> >> +    struct sk_buff *cmd_skb;
> >> +    struct qlink_cmd_start_cac *cmd;
> >> +    int ret;
> >> +    u16 res_code;
> >> +
> >> +    cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
> >> +                                        QLINK_CMD_START_CAC,
> >> +                                        sizeof(*cmd));
> >> +    if (unlikely(!cmd_skb))
> >> +            return -ENOMEM;
> >
> > The unlikely() looks pretty useless here. likely() and unlikely() are
> > supposed to be used in cases where it matters and the improvment can be
> > measured, I doubt that's the case here.

Noted once again. Though it is not easy to get rid of some habits sometimes :)

Regards,
Sergey
