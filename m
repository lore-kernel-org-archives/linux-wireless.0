Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0995EC433F5
	for <linux-wireless@archiver.kernel.org>; Fri,  6 May 2022 01:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380180AbiEFBfD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 May 2022 21:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiEFBfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 May 2022 21:35:02 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BAF1EEC7
        for <linux-wireless@vger.kernel.org>; Thu,  5 May 2022 18:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1651800681; x=1683336681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1RJ168iv1bTSwYVxSKxXDs5SZ7Oy7zBPAzxRcvnaTYI=;
  b=wJSZmx27gbm4zIIyxZrLNFF8wqPK0oll0wbzg4PIKavKU7xU9+rrg0fY
   Y8R9MdcgVc+2tfMItkXb4juHDLjDcpHFWEormdq4QXm6A6ZgBdby0nhaY
   QgyG/axvBMXS6l7DKsHASf1mZr3U6tH/wA4Xzz3AfAGMO0vepBDfXz2gK
   c=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 05 May 2022 18:31:21 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:31:21 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 5 May 2022 18:31:20 -0700
Received: from [10.253.34.102] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 18:31:19 -0700
Message-ID: <23e17fea-57f6-3908-c373-fbfcb766f25d@quicinc.com>
Date:   Fri, 6 May 2022 09:31:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/3] ath11k: Don't check arvif->is_started before sending
 management frames
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        <ath11k@lists.infradead.org>
CC:     <linux-wireless@vger.kernel.org>
References: <20220505013851.1548789-1-quic_bqiang@quicinc.com>
 <20220505013851.1548789-3-quic_bqiang@quicinc.com>
 <70b3bf3f-4b34-149a-ce1c-a8e857c6a3ac@quicinc.com>
From:   Baochen Qiang <quic_bqiang@quicinc.com>
In-Reply-To: <70b3bf3f-4b34-149a-ce1c-a8e857c6a3ac@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 5/6/2022 2:53 AM, Jeff Johnson wrote:
> On 5/4/2022 6:38 PM, Baochen Qiang wrote:
>> Commit 66307ca04057 ("ath11k: fix mgmt_tx_wmi cmd sent to FW for
>> deleted vdev") wants both of below two conditions are true before
>> sending management frames:
>>
>> 1: ar->allocated_vdev_map & (1LL << arvif->vdev_id)
>> 2: arvif->is_started
>>
>> Actually the second one is not necessary cause with the first one
>
> nit: s/cause/because/
>
Thanks Jeff, will address it in v2.
