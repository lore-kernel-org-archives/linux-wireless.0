Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26983 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab1J0IdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 04:33:10 -0400
Message-ID: <4EA9173F.3050001@qca.qualcomm.com> (sfid-20111027_103315_277967_5F5C81AA)
Date: Thu, 27 Oct 2011 11:33:03 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH] ath6kl: Fix compile error for ARM
References: <1319642918-27076-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1319642918-27076-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 06:28 PM, Sangwook Lee wrote:
> Fix the compile error for ARM Platform.
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
> ---
> 
> Compile errors come from ARM plaform:
> In file included from drivers/net/wireless/ath/ath6kl/init.c:19:0:
> include/linux/of.h: In function ‘of_property_read_u32_array’:
> include/linux/of.h:249:10: error: ‘ENOSYS’ undeclared 

In my opinion this is a bug in of.h and I sent a patch few weeks ago:

https://lkml.org/lkml/2011/10/6/133

But it seems that openfirmware maintainers don't care as I haven't
received any reply to the patch. So let's just workaround this in ath6kl.

Patch applied, but I changed the commit log a bit. Thank you again.

commit e0627e2c7e0647d174d9fcac06fa194d38740f7d
Author: Sangwook Lee <sangwook.lee@linaro.org>
Date:   Wed Oct 26 16:28:38 2011 +0100

    ath6kl: Fix compilation error from of.h

    When compiling ath6kl for ARM with device tree tree compilation fails
    with errors like:

    include/linux/of.h: In function 'of_property_read_u32_array':
    include/linux/of.h:249:10: error: 'ENOSYS' undeclared

    Workaround this by including errno.h from init.c.

    kvalo: improved commit log

    Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
