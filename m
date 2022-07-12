Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D110C433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jul 2022 02:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGLCmD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Jul 2022 22:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiGLCmB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jul 2022 22:42:01 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218B18CCA2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2022 19:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657593721; x=1689129721;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tOTRgaHK1vo51e3asPD1Ueq4NEQvEQIHawc4FbSjEKE=;
  b=qU+1GOQM8DM+xu8wstFkd+mef06pkLhPWEpGChw31Npfgr1U8qt3r4mj
   UuNslvTRaKIH0+XEE4g9e1saTqO1276M5t4H6jQ9ptIwlhcqqJnHyyh42
   Yj9Xsfa+mPEyuryekMRhRNB5qqKZixxoMgSldVuhA8/rPK3NYxusTWwvL
   8=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 11 Jul 2022 19:42:00 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 19:42:00 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 11 Jul 2022 19:42:00 -0700
Received: from [10.253.38.189] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 11 Jul
 2022 19:41:59 -0700
Message-ID: <07ad1a63-a922-aff6-75f1-4e66617602e0@quicinc.com>
Date:   Tue, 12 Jul 2022 10:41:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC v2] ath11k: fix blocked for more than 120 seconds caused by
 reg update
Content-Language: en-US
To:     Abhishek Kumar <kuabhs@chromium.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
References: <20220701072855.13655-1-quic_wgong@quicinc.com>
 <CACTWRwvispWNXAPGdUvAeRgLvUgFgb45+JTaOVX18mvhyQsQkA@mail.gmail.com>
From:   Wen Gong <quic_wgong@quicinc.com>
In-Reply-To: <CACTWRwvispWNXAPGdUvAeRgLvUgFgb45+JTaOVX18mvhyQsQkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 7/12/2022 1:54 AM, Abhishek Kumar wrote:
> This change will make the device come out of deadlock on rtnl_lock if
> that happens. Did you think of ways to completely avoid the race
> situation to occur ?
>
> Thanks
> Abhishek

You can see the commit log, if to completely avoid the race situation to 
occur,

then it need to change the rtnl_lock usage in many place in 
cfg80211/mac80211.

it will effect a lot things.


It has a change as below to reduce usage of rtnl_lock, but it does not 
remove the rtnl_lock in ath11k.

cfg80211: avoid holding the RTNL when calling the driver

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/drivers/net/wireless/ath/ath11k/reg.c?id=a05829a7222e9d10c416dd2dbbf3929fe6646b89

>
> On Fri, Jul 1, 2022 at 12:29 AM Wen Gong <quic_wgong@quicinc.com> wrote:
...
