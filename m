Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26D6C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Mar 2022 19:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiCYTkb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiCYTjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Mar 2022 15:39:20 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4907E1BB79C
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2022 12:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648235923; x=1679771923;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=bKj8TilLGdyVW9vS4DTruobfv+ddR2kfPYUpYlsH4ic=;
  b=TTgZmNGLeLgGxIJFbBDXFCH+ICXUpiKrhZyfN1abo8mYYNcQ3ScuIWTr
   jw9Aws/AKOfEZDgZjNZnMimWuWjtWNR2p7xZ6JnLgh7F3uNFASooDKY+9
   koU2gDXFINhqmm3iNg8VIhgI4pH+eOvcRiR63cayILOL8BXxoh08OnPEN
   w=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 25 Mar 2022 12:18:43 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 12:18:42 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 25 Mar 2022 12:18:42 -0700
Received: from [10.110.27.134] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 25 Mar
 2022 12:18:42 -0700
Message-ID: <bca5ba81-7e97-9b54-be57-a40df9b0634c@quicinc.com>
Date:   Fri, 25 Mar 2022 12:18:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v6 1/3] nl80211: Add support for beacon tx mode
Content-Language: en-US
To:     Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
References: <20220325055949.3035053-1-quic_mkenna@quicinc.com>
 <20220325055949.3035053-2-quic_mkenna@quicinc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220325055949.3035053-2-quic_mkenna@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/24/2022 10:59 PM, Maharaja Kennadyrajan wrote:
[...snip...]

> +/**
> + * enum nl80211_beacon_tx_mode - Beacon Tx Mode enum.
> + * @NL80211_BEACON_STAGGERED_MODE: Used to configure beacon tx mode as
> + *	staggered mode. This is the default beacon tx mode.

Documentation doesn't match the code. There is now a default mode, and 
that is, well, the default mode

> + * @NL80211_BEACON_BURST_MODE: Used to configure beacon tx mode as burst mode.
> + */
> +enum nl80211_beacon_tx_mode {
> +	NL80211_BEACON_DEFAULT_MODE = 0,
> +	NL80211_BEACON_STAGGERED_MODE = 1,
> +	NL80211_BEACON_BURST_MODE = 2,
> +};
> +
