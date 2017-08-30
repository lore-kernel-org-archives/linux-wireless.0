Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0088.outbound.protection.outlook.com ([104.47.38.88]:9969
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751393AbdH3NIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 09:08:14 -0400
Date: Wed, 30 Aug 2017 16:07:57 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 24/27] qtnfmac: configure and start AP interface with a
 single command
Message-ID: <20170830130757.vndc5ucyoreoxcht@bars> (sfid-20170830_150818_406096_527DB519)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-25-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-25-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This separation would not allow to do a proper device configuration as
> first stage needs to use information from IEs that are processed on
> a second stage. Which means first and second stages have to be meged.
> In that case there is no point anymore to keep third stage either, so
> merge all three into a single command.

typo in commit message: 'meged'

> +	if (len > (sizeof(struct qlink_cmd) + QTNF_MAX_CMD_BUF_SIZE)) {
> +		pr_err("VIF%u.%u: can not fit AP settings: %u\n",
> +		       vif->mac->macid, vif->vifid, len);
> +		return false;
>  	}

Initial len value is sizeof(struct qlink_cmd_start_ap), qlink_cmd is a part
of qlink_cmd_start_ap. So this check has to be fixed. It looks like the
simplest option is only to check payload: set initial len value to 0
and drop sizeof in comparison.
