Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36056 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbKIPkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 10:40:55 -0500
Received: by qkcl124 with SMTP id l124so72364739qkc.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 07:40:52 -0800 (PST)
Date: Mon, 9 Nov 2015 10:40:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Yin, Fengwei" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/5] wcn3620: use new response format for wcn3620
 trigger_ba
Message-ID: <20151109154040.GD5395@localhost> (sfid-20151109_164058_980433_658DF22A)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447063362-27322-5-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:02:41AM -0500, Yin, Fengwei wrote:
> From: Andy Green <andy.green@linaro.org>
> 
> From: Andy Green <andy.green@linaro.org>
> 
> On wcn3620, firmware response to trigger_ba uses the new, larger
> "v2" format

> -	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +	ret = wcn36xx_smd_rsp_status_check_v2(wcn, wcn->hal_buf,
> +						wcn->hal_rsp_len);

It's unclear from the changelog -- is it safe to call
wcn36xx_smd_rsp_status_check_v2 on the 3660/3680 as well?

Is wcn36xx_smd_rsp_status_check() still needed?

-- 
Bob Copeland %% http://bobcopeland.com/
