Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF050C433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 25 May 2022 18:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343728AbiEYSby (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 May 2022 14:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244811AbiEYSbv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 May 2022 14:31:51 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F11DB2243
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2022 11:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1653503510; x=1685039510;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VE8XDzK3iqON8U+BVKZTmVnygqREBbmQVPD3sFx9heg=;
  b=u1EWQh6N+bNe7+mOrTmSUGfZ5ifVEpgK4ljELxWOVX3RzFNynq7Z1GIC
   Vk0BpD0H0CJS1aSaVkYOMZgBH3Zu4TZ59S5cefb/fAUd9dQwUyKl4fj6T
   atKWxpMvtTmgFLu166RYLEDHj5lL4nVe0gMcZR5sHa4PtY4+xOeLbXclk
   U=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 25 May 2022 11:31:50 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 11:31:50 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 25 May 2022 11:31:49 -0700
Received: from [10.110.85.248] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 25 May
 2022 11:31:48 -0700
Message-ID: <9511a760-f842-af77-21f9-6bdf9d4561f6@quicinc.com>
Date:   Wed, 25 May 2022 11:31:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC v2 16/96] cl8k: add config.h
Content-Language: en-US
To:     <viktor.barna@celeno.com>, <linux-wireless@vger.kernel.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aviad Brikman <aviad.brikman@celeno.com>,
        Eliav Farber <eliav.farber@gmail.com>,
        "Maksym Kokhan" <maksym.kokhan@celeno.com>,
        Oleksandr Savchenko <oleksandr.savchenko@celeno.com>,
        Shay Bar <shay.bar@celeno.com>
References: <20220524113502.1094459-1-viktor.barna@celeno.com>
 <20220524113502.1094459-17-viktor.barna@celeno.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220524113502.1094459-17-viktor.barna@celeno.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 5/24/2022 4:33 AM, viktor.barna@celeno.com wrote:
[snip]

> +#define READ_BOOL(param) \
> +{ \
> +	if (!strcmp(name, #param)) { \
> +		bool new_val = false; \
> +		ret = kstrtobool(value, &new_val); \
> +		if (ret) { \
> +			pr_err("%s: invalid value [%s]\n", #param, value); \
> +			break; \
> +		} \
> +		if (conf->param != new_val) { \
> +			pr_debug("%s: old value %u -> new value %u\n", \
> +				 #param, conf->param, new_val); \
> +			conf->param = new_val; \
> +		} \
> +		break; \
> +	} \
> +}

You should review the guidance on macros at
<https://www.kernel.org/doc/html/latest/process/coding-style.html#macros-enums-and-rtl>

Note that things to avoid include:
1. macros that affect control flow
2. macros that depend on having a local variable with a magic name

