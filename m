Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDEBC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 332E32077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfDZTum (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:50:42 -0400
Received: from nbd.name ([46.4.11.11]:39198 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfDZTul (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 15:50:41 -0400
Received: from p548c8674.dip0.t-ipconnect.de ([84.140.134.116] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hK6ri-00038v-LH; Fri, 26 Apr 2019 21:50:34 +0200
Subject: Re: [PATCH V2 1/3] mac80211: allow turning TWT responder support on
 and off via netlink
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Srini Kode <skode@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        ath11k@lists.infradead.org
References: <20190426094150.18078-1-john@phrozen.org>
 <20190426094150.18078-2-john@phrozen.org>
From:   John Crispin <john@phrozen.org>
Message-ID: <2f153f21-17fe-26aa-98a4-b82cdb16ffff@phrozen.org>
Date:   Fri, 26 Apr 2019 21:50:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426094150.18078-2-john@phrozen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 26/04/2019 11:41, John Crispin wrote:
> @@ -6105,6 +6106,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>   	params.ht_opmode = -1;
>   	params.p2p_ctwindow = -1;
>   	params.p2p_opp_ps = -1;
> +	params.twt_responder = -1;
>   
>   	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
>   		params.use_cts_prot =
> @@ -6149,6 +6151,10 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>   			return -EINVAL;
>   	}
>   
> +	if (info->attrs[NL80211_ATTR_TWT_RESPONDER])
> +		params.twt_responder =
> +		    nla_get_u8(info->attrs[NL80211_ATTR_TWT_RESPONDER]);
> +
>   	if (!rdev->ops->change_bss)
>   		return -EOPNOTSUPP;

Hi,

this should probably be moved to nl80211_start_ap() instead of 
nl80211_set_bss() as we probably dont want to change this at runtime ?

     John

