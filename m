Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB474C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6ED8206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 19:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfDZTxL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:53:11 -0400
Received: from nbd.name ([46.4.11.11]:39394 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbfDZTxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 15:53:11 -0400
Received: from p548c8674.dip0.t-ipconnect.de ([84.140.134.116] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hK6uB-0003OK-Py; Fri, 26 Apr 2019 21:53:07 +0200
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
 <2f153f21-17fe-26aa-98a4-b82cdb16ffff@phrozen.org>
 <8b456918fc5cd0674f834771be2bb5134bccd26a.camel@sipsolutions.net>
From:   John Crispin <john@phrozen.org>
Message-ID: <d60c3032-b432-c2ee-95e2-edffed75c87a@phrozen.org>
Date:   Fri, 26 Apr 2019 21:53:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8b456918fc5cd0674f834771be2bb5134bccd26a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 26/04/2019 21:51, Johannes Berg wrote:
> On Fri, 2019-04-26 at 21:50 +0200, John Crispin wrote:
>> On 26/04/2019 11:41, John Crispin wrote:
>>> @@ -6105,6 +6106,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>>>    	params.ht_opmode = -1;
>>>    	params.p2p_ctwindow = -1;
>>>    	params.p2p_opp_ps = -1;
>>> +	params.twt_responder = -1;
>>>    
>>>    	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
>>>    		params.use_cts_prot =
>>> @@ -6149,6 +6151,10 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>>>    			return -EINVAL;
>>>    	}
>>>    
>>> +	if (info->attrs[NL80211_ATTR_TWT_RESPONDER])
>>> +		params.twt_responder =
>>> +		    nla_get_u8(info->attrs[NL80211_ATTR_TWT_RESPONDER]);
>>> +
>>>    	if (!rdev->ops->change_bss)
>>>    		return -EOPNOTSUPP;
>> Hi,
>>
>> this should probably be moved to nl80211_start_ap() instead of
>> nl80211_set_bss() as we probably dont want to change this at runtime ?
> I have no idea, can we change it at runtime? Is it a capability or an
> operational state?
>
> johannes

its a capability, only the twt_required bit is an operational state. so 
I shall send a V3 moving it to start_ap() :-)

     John

