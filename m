Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BD9C43334
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jun 2022 20:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbiFBUlJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Jun 2022 16:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiFBUlI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Jun 2022 16:41:08 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4DF99
        for <linux-wireless@vger.kernel.org>; Thu,  2 Jun 2022 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654202466; x=1685738466;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FjW0a9LgTHm5QyIvCCVQBapz9nw9A3r45AIKyo3Up9Q=;
  b=hUZdBpjBtomrahDKZYBeMh+kFXwwbSDIVmp1Hsjdn73SrU/BO8nRmkke
   0uXCNnoAtcKqETOFCPsWQcsmEzCy2eVqohS98QJ2kzwDGWrwH8tn4Z2h5
   bo3709IpMOGVDIeLsi+YsYEvvCL7zVGXRv4niyOKMxgZYu2tmc+QHwbB+
   A=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 02 Jun 2022 13:41:06 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 13:41:05 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 2 Jun 2022 13:40:25 -0700
Received: from [10.110.9.238] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 2 Jun 2022
 13:40:24 -0700
Message-ID: <8bf132e6-9a31-075a-c592-0f4025425cb8@quicinc.com>
Date:   Thu, 2 Jun 2022 13:40:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC v2 67/96] cl8k: add rfic.h
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
 <20220524113502.1094459-68-viktor.barna@celeno.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220524113502.1094459-68-viktor.barna@celeno.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 5/24/2022 4:34 AM, viktor.barna@celeno.com wrote:
> From: Viktor Barna <viktor.barna@celeno.com>
> 
> (Part of the split. Please, take a look at the cover letter for more
> details).
> 
> Signed-off-by: Viktor Barna <viktor.barna@celeno.com>
> ---
>   drivers/net/wireless/celeno/cl8k/rfic.h | 29 +++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>   create mode 100644 drivers/net/wireless/celeno/cl8k/rfic.h
> 
> diff --git a/drivers/net/wireless/celeno/cl8k/rfic.h b/drivers/net/wireless/celeno/cl8k/rfic.h
> new file mode 100644
> index 000000000000..686ebd6fcd98
> --- /dev/null
> +++ b/drivers/net/wireless/celeno/cl8k/rfic.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> +/* Copyright(c) 2019-2022, Celeno Communications Ltd. */
> +
> +#ifndef CL_RFIC_H
> +#define CL_RFIC_H
> +
> +#include "hw.h"
> +
> +#define ATHOS_A_VER    0xB1
> +#define ATHOS_B_VER    0xB2
> +
> +enum cl_rf_overwrite_cmd {
> +	OVERWRITE_DONE,
> +	SPI_RD_CMD,
> +	SPI_WR_CMD,
> +	GCU_WR_CMD,
> +	RIU_WR_CMD,
> +	UDELAY_CMD,
> +	GEN_WR_CMD,
> +	RF_OVERWRITE_CMD_MAX = OVERWRITE_DONE

consider adding CL_ prefix to the enumerators to avoid namespace collision.

why is OVERWRITE_DONE the max command? that doesn't seem to make sense 
since other enumerators are defined after it.

> +};
> +
> +int cl_spi_driver_read_byte(struct cl_hw *cl_hw, u8 page, u8 addr, u8 *val);
> +int cl_spi_read(struct cl_hw *cl_hw, u8 page, u8 addr, u8 *val);
> +int cl_rfic_read_overwrite_file(struct cl_hw *cl_hw,
> +				struct cl_rf_reg_overwrite_info *info,
> +				bool init);
> +void cl_chip_set_rfic_version(struct cl_hw *cl_hw);
> +#endif /* CL_RFIC_H */

