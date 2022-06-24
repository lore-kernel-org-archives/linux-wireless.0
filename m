Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB4ECCA473
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jun 2022 18:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiFXS7b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiFXS72 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jun 2022 14:59:28 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD847C53B;
        Fri, 24 Jun 2022 11:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656097168; x=1687633168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZkJlVC384UNpflENkvCHqRU0Ni7nxmoR7Jcb/6VX51s=;
  b=kxkKZjc1nzvBtRfk30aZIwd+z/+q/wSLgmlRL/gGD4JMmpmzrODj86KZ
   9iJ1hO2/+lLdQKXPvy30OstE7e+8GaGBI8QclR9jfgXautYgSMiQ0+0sQ
   wf47/P08vvlvmWIZcmRXkDNtgnie9i/TAGi9qy2lvNqewxnPJQqDXvywO
   M=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 24 Jun 2022 11:59:27 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 11:59:27 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 11:59:27 -0700
Received: from [10.110.111.5] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 24 Jun
 2022 11:59:26 -0700
Message-ID: <0251f2c9-0f66-7dc9-7fb6-cc41a8dfd918@quicinc.com>
Date:   Fri, 24 Jun 2022 11:59:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related
 functions
Content-Language: en-US
To:     Paul Cercueil <paul@crapouillou.net>
CC:     Arend Van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220623124221.18238-1-paul@crapouillou.net>
 <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
 <3013994a-487c-56eb-42d6-b8cdf7615405@quicinc.com>
 <WHVZDR.GB0H9SQC9PDP@crapouillou.net>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <WHVZDR.GB0H9SQC9PDP@crapouillou.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 6/24/2022 11:32 AM, Paul Cercueil wrote:
> Hi,
> 
> Le ven., juin 24 2022 at 09:31:22 -0700, Jeff Johnson 
> <quic_jjohnson@quicinc.com> a écrit :
>> On 6/24/2022 2:24 AM, Arend Van Spriel wrote:
>>> On 6/23/2022 2:42 PM, Paul Cercueil wrote:
>>
>> [snip]
>>
>>>> -    if (sdiodev->freezer) {
>>>> +    if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {
>>>
>>> This change is not necessary. sdiodev->freezer will be NULL when 
>>> CONFIG_PM_SLEEP is not enabled.
>>
>> but won't the compiler be able to completely optimize the code away if 
>> the change is present?
> 
> That's correct. But do we want to complexify a bit the code for the sake 
> of saving a few bytes? I leave that as an open question to the 
> maintainer, I'm really fine with both options.

I'm fine either way as well. I'd have stronger opinions if ath drivers 
were involved ;)
