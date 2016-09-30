Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42655 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932418AbcI3M3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:29:48 -0400
Message-ID: <1475238579.17481.56.camel@sipsolutions.net> (sfid-20160930_142951_993597_F34BFB74)
Subject: Re: [PATCH 1/3] cw1200: Don't leak memory if krealloc failes
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Thumshirn <jthumshirn@suse.de>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Sep 2016 14:29:39 +0200
In-Reply-To: <1475237495-15030-1-git-send-email-jthumshirn@suse.de> (sfid-20160930_141208_240938_8F56ACB3)
References: <1475237495-15030-1-git-send-email-jthumshirn@suse.de>
         (sfid-20160930_141208_240938_8F56ACB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	tmp = krealloc(buf->begin, size, GFP_KERNEL | GFP_DMA);
> +	if (tmp) {
> 
I think that check is inverted?

johannes
