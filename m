Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43352 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbcLEOqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:46:31 -0500
Message-ID: <1480949161.31788.23.camel@sipsolutions.net> (sfid-20161205_154707_457754_35E349D2)
Subject: Re: [PATCH 1/4] cfg80211: Add support to enable or disable btcoex
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, tamizhchelvam@codeaurora.org
Date: Mon, 05 Dec 2016 15:46:01 +0100
In-Reply-To: <1478610932-21954-2-git-send-email-c_traja@qti.qualcomm.com>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-2-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-08 at 18:45 +0530, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> This patch adds support to enable or disable btcoex by
> adding NL80211_ATTR_WIPHY_BTCOEX_ENABLE attribute in
> NL80211_CMD_SET_WIPHY command. By default BTCOEX disabled in driver.

I think overloading SET_WIPHY even more is a mistake - why not group
this with the new command you're introducing in the second patch?

Also, can have a flag attribute to enable/disable, or better even
disable when you're not setting any other parameters.

johannes
