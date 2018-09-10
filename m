Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:48470 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeIJMCx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 08:02:53 -0400
Message-ID: <1536563406.3224.2.camel@sipsolutions.net> (sfid-20180910_091027_333188_88825C63)
Subject: Re: [PATCH] wireless: remove unnecessary condition check before
 kfree
From: Johannes Berg <johannes@sipsolutions.net>
To: zhong jiang <zhongjiang@huawei.com>, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Sep 2018 09:10:06 +0200
In-Reply-To: <1536415955-33776-1-git-send-email-zhongjiang@huawei.com>
References: <1536415955-33776-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 22:12 +0800, zhong jiang wrote:
> kfree has taken the null pointer into account. Just remove the
> redundant condition check before kfree.

I'm all for doing that if it actually removes conditionals, but

> -	if (!IS_ERR_OR_NULL(regdb))
> +	if (!IS_ERR(regdb))
>  		kfree(regdb);

this seems rather pointless since there's still a condition. In that
case, I feel it's easier to understand the original code.

johannes
