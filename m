Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42812 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcLENv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 08:51:26 -0500
Message-ID: <1480945883.31788.3.camel@sipsolutions.net> (sfid-20161205_145130_572619_22E6D64F)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 14:51:23 +0100
In-Reply-To: <20161202205611.14141-1-andrew.zaborowski@intel.com> (sfid-20161202_221617_913447_8760246C)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         (sfid-20161202_221617_913447_8760246C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-02 at 21:56 +0100, Andrew Zaborowski wrote:
> Disconnect or deauthenticate when the owning socket is closed if this
> flag has been supplied to CMD_CONNECT, CMD_AUTHENTICATE or
> CMD_ASSOCIATE.

Huh. That I think needs a lot more commit log to justify this code -
why do you think this would be useful? Connection managers dying don't
really mean you need to disconnect immediately, after all, and if they
restart it's pretty simple to detect the existing connection and
perhaps even use it...

johannes
