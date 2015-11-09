Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33756 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbKIPoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 10:44:06 -0500
Received: by qgea14 with SMTP id a14so64464016qge.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 07:44:04 -0800 (PST)
Date: Mon, 9 Nov 2015 10:43:52 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Yin, Fengwei" <fengwei.yin@linaro.org>
Cc: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 3/5] wcn36xx: handle new hal response format
Message-ID: <20151109154352.GE5395@localhost> (sfid-20151109_164410_916938_409977F5)
References: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org>
 <1447063362-27322-4-git-send-email-fengwei.yin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447063362-27322-4-git-send-email-fengwei.yin@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:02:40AM -0500, Yin, Fengwei wrote:
> 
> From: Andy Green <andy.green@linaro.org>
> 
> wcn3620 has a new message structure for the reply to some hal
> commands.  This patch adds the struct and helper routine that
> uses it if the chip is wcn3620, or falls back to the old
> helper routine.

> +	if (wcn->chip_version != WCN36XX_CHIP_3620 ||
> +	    len < sizeof(struct wcn36xx_hal_msg_header) + sizeof(*rsp))
> +		return wcn36xx_smd_rsp_status_check(buf, len);
> +

Ok, disregard my question on the other patch, for some reason I
read them out of order.  It looks like this should work ok with
non-3620 chips.

-- 
Bob Copeland %% http://bobcopeland.com/
