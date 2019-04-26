Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D4FC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE2520675
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfDZItY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 04:49:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53636 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZItY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 04:49:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJwXo-0006hN-9E; Fri, 26 Apr 2019 10:49:20 +0200
Message-ID: <b35bf3e3778858cf95d4e8b743a884e4cc424798.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: allow turning TWT responder support on
 and off via netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Date:   Fri, 26 Apr 2019 10:49:17 +0200
In-Reply-To: <20190426084244.28098-2-john@phrozen.org>
References: <20190426084244.28098-1-john@phrozen.org>
         <20190426084244.28098-2-john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-26 at 10:42 +0200, John Crispin wrote:
> 
> +++ b/net/wireless/nl80211.c
> @@ -6105,6 +6105,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>  	params.ht_opmode = -1;
>  	params.p2p_ctwindow = -1;
>  	params.p2p_opp_ps = -1;
> +	params.twt_responder = -1;
>  
>  	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
>  		params.use_cts_prot =
> @@ -6149,6 +6150,10 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>  			return -EINVAL;
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_TWT_RESPONDER])
> +		params.twt_responder =
> +		    nla_get_u8(info->attrs[NL80211_ATTR_TWT_RESPONDER]);

You need an NLA_POLICY_RANGE() policy for that attribute.

johannes

