Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB98C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 598702077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfDZTva (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:51:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41404 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfDZTva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 15:51:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK6sZ-0000aD-JN; Fri, 26 Apr 2019 21:51:27 +0200
Message-ID: <8b456918fc5cd0674f834771be2bb5134bccd26a.camel@sipsolutions.net>
Subject: Re: [PATCH V2 1/3] mac80211: allow turning TWT responder support on
 and off via netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Srini Kode <skode@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        ath11k@lists.infradead.org
Date:   Fri, 26 Apr 2019 21:51:26 +0200
In-Reply-To: <2f153f21-17fe-26aa-98a4-b82cdb16ffff@phrozen.org>
References: <20190426094150.18078-1-john@phrozen.org>
         <20190426094150.18078-2-john@phrozen.org>
         <2f153f21-17fe-26aa-98a4-b82cdb16ffff@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-26 at 21:50 +0200, John Crispin wrote:
> On 26/04/2019 11:41, John Crispin wrote:
> > @@ -6105,6 +6106,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
> >   	params.ht_opmode = -1;
> >   	params.p2p_ctwindow = -1;
> >   	params.p2p_opp_ps = -1;
> > +	params.twt_responder = -1;
> >   
> >   	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
> >   		params.use_cts_prot =
> > @@ -6149,6 +6151,10 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
> >   			return -EINVAL;
> >   	}
> >   
> > +	if (info->attrs[NL80211_ATTR_TWT_RESPONDER])
> > +		params.twt_responder =
> > +		    nla_get_u8(info->attrs[NL80211_ATTR_TWT_RESPONDER]);
> > +
> >   	if (!rdev->ops->change_bss)
> >   		return -EOPNOTSUPP;
> 
> Hi,
> 
> this should probably be moved to nl80211_start_ap() instead of 
> nl80211_set_bss() as we probably dont want to change this at runtime ?

I have no idea, can we change it at runtime? Is it a capability or an
operational state?

johannes

