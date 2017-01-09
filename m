Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39638 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965699AbdAILXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:23:32 -0500
Message-ID: <1483961010.17582.32.camel@sipsolutions.net> (sfid-20170109_122439_881558_4EEA6529)
Subject: Re: [PATCH v5] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Jan 2017 12:23:30 +0100
In-Reply-To: <20170106213343.6598-1-andrew.zaborowski@intel.com> (sfid-20170106_223357_427320_4F3F254F)
References: <20170106213343.6598-1-andrew.zaborowski@intel.com>
         (sfid-20170106_223357_427320_4F3F254F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-06 at 16:33 -0500, Andrew Zaborowski wrote:
> Disconnect or deauthenticate when the owning socket is closed if this
> flag is supplied to CMD_CONNECT or CMD_ASSOCIATE.  This may be used
> to ensure userspace daemon doesn't leave an unmanaged connection
> behind.
> 
> In some situations it would be possible to account for that, to some
> degree, in the deamon restart code or in the up/down scripts without
> the use of this attribute.  But there will be systems where the
> daemon
> can go away for varying periods without a warning due to local
> resource
> management.
> 

Applied. Turns out there's no conflict with the other change after all,
since the context here doesn't include the pieces I changed (and this
time the "else if" is correct, since disconnecting explicitly is
pointless when the interface is about to be destroyed)

johannes
