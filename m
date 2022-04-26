Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45199C433F5
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Apr 2022 11:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349580AbiDZLpo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346071AbiDZLpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Apr 2022 07:45:43 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A393BA57
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2022 04:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650973355; x=1682509355;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=AeNSb0FKkbLoHTZHKt+yir9RlhqqMU/vKU5zgdB3ehw=;
  b=p0qx4AadMdqwnH9frtGjIWZAmQL587bfJNdE4JibVNPy5v1k9tWFpj6k
   Qnno0Q8woo34Yc1psAFwMHcSq+1qK56hLKmMLhpYLUntoMD5WRDz2Uo8j
   TsWzbHYB07qmu9uOQp2ToGXmHJX2oT/5/njfGd87horE85tn8uUBXq87G
   0=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 26 Apr 2022 04:42:35 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 04:42:34 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 04:42:34 -0700
Received: from [10.50.24.135] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 04:42:31 -0700
Message-ID: <9560c693-8dd5-ba68-69ca-dd3d213584e6@quicinc.com>
Date:   Tue, 26 Apr 2022 17:12:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH] cfg80211: do some rework towards MLO link APIs
Content-Language: en-CA
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
References: <20220414145522.116716-1-johannes@sipsolutions.net>
 <f137ca7f-8b59-3368-c666-247f83d80383@quicinc.com>
 <6b40798e349d11e495a6df20ecba479a8357dad2.camel@sipsolutions.net>
From:   Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>
In-Reply-To: <6b40798e349d11e495a6df20ecba479a8357dad2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/26/2022 12:46 PM, Johannes Berg wrote:
>>   > +	if (internal_flags & NL80211_FLAG_MLO_VALID_LINK_ID) {
>>   > +		struct nlattr *link_id = info->attrs[NL80211_ATTR_MLO_LINK_ID];
> 
> [...]
>>   > +		/* non-MLO -> no link ID attribute accepted */
>>   > +		if (!wdev->valid_links && link_id) {
>>
>> Isn't that we hit this condition when adding the very first link to the
>> MLD using NL80211_CMD_ADD_LINK?
>>
> 
> Oh, I don't think CMD_ADD_LINK would set NL80211_FLAG_MLO_VALID_LINK_ID,
> that's just helper functionality for those commands that expect
> everything to already be set up.

got it, thanks!

Vasanth
