Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33542 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdJBMaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 08:30:23 -0400
Message-ID: <1506947421.25586.10.camel@sipsolutions.net> (sfid-20171002_142830_986646_D39ACB51)
Subject: Re: [RFC] Add cfg80211/nl80211 support for AP mode 802.11 FT roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: wil6210 <wil6210@qca.qualcomm.com>
Date: Mon, 02 Oct 2017 14:30:21 +0200
In-Reply-To: <000901d335fa$0483f7d0$0d8be770$@codeaurora.org>
References: <000901d335fa$0483f7d0$0d8be770$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-09-25 at 15:30 +0300, Dedy Lansky wrote:
> From: Dedy Lansky <dlansky@codeaurora.org>
> 
> Drivers which have integrated AP SME can use this to communicate with
> userspace (e.g. hostapd) for the purpose of FT roaming processing.
> 
> cfg80211 API added for driver to indicate received Authentication and
> Reassociation frames from the roaming STA.
> NL80211_CMD_AUTHENTICATE and NL80211_CMD_ASSOCIATE are enhanced to be
> used
> in AP mode, for indication/response to/from userspace.

That description could use some work :)

It's not quite clear to me why this needs new API, and new semantics
for the existing AUTH/ASSOC commands. In fact, the latter I dislike
most, because those commands/events are only used in client mode right
now, and having them in AP mode now seems confusing.

Perhaps just mirroring the frames to userspace with CMD_FRAME, if
needed with a new flag that they're already handled or so would be
better?

johannes
