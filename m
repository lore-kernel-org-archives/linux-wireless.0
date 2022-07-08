Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7008BC43334
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Jul 2022 19:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbiGHT2R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239790AbiGHT2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jul 2022 15:28:08 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DA4599FF
        for <linux-wireless@vger.kernel.org>; Fri,  8 Jul 2022 12:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657308478; x=1688844478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xY9IygEBOQh2ladECOAFIjj2xLxGoKGvI3yFFMS75ZY=;
  b=pCm4mxUiX/sJouMkA5Z++yiBmF3Vp9U3vhKqGUBBPRdzXgPrB8XgJbvP
   xZZDgwIme2oYbNXkdBdxXWdFKQNZ4ofwtbMoiTQpJSdj3eIyk1rM1iiiS
   wTRvi25b/0yZKGRca8CsG047AGql5unles5ecG02VK8/EiNlWuBPbAYDO
   I=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 08 Jul 2022 12:27:57 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 12:27:57 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 8 Jul 2022 12:27:56 -0700
Received: from [10.110.101.120] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 8 Jul 2022
 12:27:55 -0700
Message-ID: <bc47dcaf-acee-89c3-ca7e-ef15a4f2205f@quicinc.com>
Date:   Fri, 8 Jul 2022 12:27:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] wifi: nl80211: fix sending link ID info of associated
 BSS
Content-Language: en-US
To:     Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <20220708122607.1836958-1-quic_vjakkam@quicinc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220708122607.1836958-1-quic_vjakkam@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 7/8/2022 5:26 AM, Veerendranath Jakkam wrote:
> commit dd374f84baec ("wifi: nl80211: expose link ID for associated
>   BSSes") used a top-level attribute to send link ID of the associated
> BSS in the nested attribute NL80211_ATTR_BSS. But since NL80211_ATTR_BSS
> is a nested attribute of the attributes defined in enum nl80211_bss,
> define a new attribute in enum nl80211_bss and use it for sending the
> link ID of the BSS.
> 
> Fixes: dd374f84baec ("wifi: nl80211: expose link ID for associated BSSes")
> Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
