Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C492C43334
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jul 2022 00:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiGLA4F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGLA4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jul 2022 20:56:04 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CD22A72C
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2022 17:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657587363; x=1689123363;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=0090zWVa2AslLxcfJGhjj/6B3Kyfvi31R8og1Hvh+gU=;
  b=NBiiF0iJHBOmhZU8UwLkqBdXIKABiDgnDRNVfe3xL04gaQ0fH5jvAWdV
   Y6N0NOQZzN8+LEca5kDXAlcOODAWE1zuVfncbkMymQ6x7zFkA43H1cQM6
   Mp3LcHZK1i2xPqQVfXIXxqy4h63uFtnDuTd4mkPTJqesyrbXVjlNTGvjo
   A=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 11 Jul 2022 17:56:03 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 17:56:03 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 11 Jul 2022 17:56:03 -0700
Received: from [10.110.97.41] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 11 Jul
 2022 17:56:02 -0700
Message-ID: <f662a668-fb16-61b0-cfb2-886c1fb72261@quicinc.com>
Date:   Mon, 11 Jul 2022 17:56:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] nl80211: Fix reading NL80211_ATTR_MLO_LINK_ID in
 nl80211_pre_doit
Content-Language: en-US
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <1657517683-5724-1-git-send-email-quic_vjakkam@quicinc.com>
 <0d61898f-f17a-d8e5-a35d-8da85d7c973d@quicinc.com>
In-Reply-To: <0d61898f-f17a-d8e5-a35d-8da85d7c973d@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 7/11/2022 8:59 AM, Jeff Johnson wrote:
> On 7/10/2022 10:34 PM, Veerendranath Jakkam wrote:
>> nl80211_pre_doit() using nla_get_u16() to read u8 attribute
> 
> I would be more explicit and say:
> nl80211_pre_doit() is incorrectly using ...

but I see this is already in wireless-next so nevermind :)
