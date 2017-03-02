Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47614 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754440AbdCBIpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 03:45:04 -0500
Message-ID: <1488444301.8390.6.camel@sipsolutions.net> (sfid-20170302_094549_759097_EEB12248)
Subject: Re: [PATCHv2 1/4] cfg80211: Add support to enable or disable btcoex
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Date: Thu, 02 Mar 2017 09:45:01 +0100
In-Reply-To: <1488029873-14600-2-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-2-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You need to fix the build-bot warning, it's legitimate (though hard to
spot):

> +	TP_printk(WIPHY_PR_FMT, ", enabled=%d",
> +		  WIPHY_PR_ARG, __entry->enabled)
> +);

You have a stray comma there after WIPHY_PR_FMT.

johannes
