Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CF7C43334
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jun 2022 16:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiFXQb0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jun 2022 12:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFXQbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jun 2022 12:31:25 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5C650B2B;
        Fri, 24 Jun 2022 09:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656088285; x=1687624285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gvN50YTRbbw/CZbnbMbOb1TEK/TeMnMyqf/OR0LURDo=;
  b=Iz9RJy8/dEyC9gJ6UX3YjRORilXyvUEdP3tQk4iq5gnU6wOUL9OLaF+6
   mcHHPn9bRUCq92e+VrXuYWBT91cVA4XZOK/CrdrWFeUy2O8IWQfBtTqP2
   fIPTvk1LpJ3VwAmkTKSQ7I2wCc2zR9hb8oklvOi8sFl3wmYUuryDKSC9D
   U=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 24 Jun 2022 09:31:25 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 09:31:24 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 24 Jun 2022 09:31:24 -0700
Received: from [10.110.111.5] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 24 Jun
 2022 09:31:23 -0700
Message-ID: <3013994a-487c-56eb-42d6-b8cdf7615405@quicinc.com>
Date:   Fri, 24 Jun 2022 09:31:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related
 functions
Content-Language: en-US
To:     Arend Van Spriel <aspriel@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Franky Lin <franky.lin@broadcom.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220623124221.18238-1-paul@crapouillou.net>
 <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 6/24/2022 2:24 AM, Arend Van Spriel wrote:
> On 6/23/2022 2:42 PM, Paul Cercueil wrote:

[snip]

>> -    if (sdiodev->freezer) {
>> +    if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {
> 
> This change is not necessary. sdiodev->freezer will be NULL when 
> CONFIG_PM_SLEEP is not enabled.

but won't the compiler be able to completely optimize the code away if 
the change is present?
