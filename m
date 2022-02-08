Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66599C47088
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386547AbiBHW0k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386579AbiBHUzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Feb 2022 15:55:12 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE77C0612C3
        for <linux-wireless@vger.kernel.org>; Tue,  8 Feb 2022 12:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1644353711; x=1675889711;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CV1/8lNW/lhsJcj0a0+SXyb569vpKJ7pWQm1uQieEpw=;
  b=bqvC7txBnjXkPix+/VsubJ9ArwRTVm30ixvJJM714AJChjxVyJ15ySww
   eJ9pHd1rFgtU77TDwgBG7rzOvtTi5bIBWEqn5hjVlC4sr+0VO+2PY8DCH
   IeREGAKcVW8DNbB2I+WOkbl5DNFw3EMDqPBsW4LkhmtHzXC+rtdGtCHQd
   w=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 08 Feb 2022 12:55:11 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 12:55:11 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Tue, 8 Feb 2022 12:55:10 -0800
Received: from [10.48.246.62] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Tue, 8 Feb 2022
 12:55:10 -0800
Message-ID: <23784b65-745a-b269-74c9-172d414ed752@quicinc.com>
Date:   Tue, 8 Feb 2022 12:55:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 1/6] ath11k: Add basic WoW functionalities
Content-Language: en-US
To:     Carl Huang <quic_cjhuang@quicinc.com>, <ath11k@lists.infradead.org>
CC:     <linux-wireless@vger.kernel.org>
References: <1644308006-22784-1-git-send-email-quic_cjhuang@quicinc.com>
 <1644308006-22784-2-git-send-email-quic_cjhuang@quicinc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <1644308006-22784-2-git-send-email-quic_cjhuang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/8/2022 12:13 AM, Carl Huang wrote:
> Implement basic WoW functionalities such as magic-packet, disconnect
> and pattern. The logic is very similar to ath10k.
> 
> When WoW is configured, ath11k_core_suspend and ath11k_core_resume
> are skipped as WoW configuration and hif suspend/resume are done in
> ath11k_wow_op_suspend() and ath11k_wow_op_resume().
> 
> Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
> 
> Signed-off-by: Carl Huang <quic_cjhuang@quicinc.com>
> Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>


Carl your S-O-B should be last since you are submitting the change

