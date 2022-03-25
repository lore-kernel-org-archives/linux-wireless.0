Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1914C433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Mar 2022 15:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359529AbiCYQAn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Mar 2022 12:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359447AbiCYQAm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Mar 2022 12:00:42 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470D34339D
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2022 08:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648223948; x=1679759948;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aKiQSriddwKV8y9vw6EQCkKlLcQ2c6RtG50HX3vecW8=;
  b=TeEP+HqcRupn/d8cNd5Fw3QVzbRg1LJoveWBSmncCHIIIRVrInSgCmZ5
   s2bhjITl/liunQ0xBAZKhH3O4RTLH7gZWazObs9RmfQbpT6x3nHKMons5
   b1VtDdekRiT1KXxXAlMnOKHiCUl91MNDmvUjvb6+S3QyK9+63Lx13VFQv
   I=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 25 Mar 2022 08:59:08 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 08:59:08 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 25 Mar 2022 08:59:07 -0700
Received: from [10.110.27.134] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 25 Mar
 2022 08:59:07 -0700
Message-ID: <2b2fa5d9-238a-81fa-8978-94bd9753b73e@quicinc.com>
Date:   Fri, 25 Mar 2022 08:59:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        William McVicker <willmcvicker@google.com>
CC:     <linux-wireless@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <0000000000009e9b7105da6d1779@google.com>
 <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
 <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <ada45791b8792f37d4167d24a7fc440f77c2167f.camel@sipsolutions.net>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <ada45791b8792f37d4167d24a7fc440f77c2167f.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/25/2022 5:09 AM, Johannes Berg wrote:
> On Tue, 2022-03-22 at 21:58 +0000, William McVicker wrote:
>>
>> It would be nice if nl80211_vendor_cmd() could support taking the RTNL lock if
>> requested via the vendor flags. That would require moving the wiphy lock to
>> nl80211_vendor_cmds() so that it could take the RTNL and wiphy lock in the
>> correct order. Is that something you'd be open to Johannes?
> 
> Not very, to be honest. If we had a good use case for it, maybe, but
> you're not even saying quite what the use case is :)

I believe Will and I are up against the same issues. Out-of-tree Android 
drivers use a large number of vendor commands to support the 
requirements of the Android framework. Prior to 5.12 these vendor 
commands would always be called with the rtnl lock held, and in some 
cases the implementation of the vendor commands care about that, 
especially when calling back into the kernel. In particular we are faced 
with the issue that there are some kernel APIs that require that the 
rtnl lock be held, and as a result of the lock infrastructure change we 
can no longer call those APIs from vendor commands. That is a pretty 
severe limitation to work around.

/jeff
