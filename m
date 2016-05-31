Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbcEaKQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:16:47 -0400
Message-ID: <1464689804.3076.13.camel@sipsolutions.net> (sfid-20160531_121651_506085_DE5BA53F)
Subject: Re: [PATCH iw] add "channels" PHY command listing frequencies with
 more details
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 12:16:44 +0200
In-Reply-To: <1463739223-19205-1-git-send-email-zajec5@gmail.com> (sfid-20160520_121359_756163_22E700AE)
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	 (sfid-20160520_121359_756163_22E700AE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-05-20 at 12:13 +0200, Rafał Miłecki wrote:
> Channels (frequencies) are getting more details that users may want
> to
> know about. E.g. it's important to know which frequencies allow using
> 40/80/160 MHz channels to setup AP properly.
> 
> We list channels in "info" command output but it's already quite big
> and
> it was agreed to introduce new command rather than expand the old
> one.
> 
> This patch adds "channels" command printing what was already
> available
> in the "info" plus details about supported channel widths. It also
> removes DFS info from the "info" output.

Very nice.

Unfortunately, I get compiler warnings about width_* being possibly
used uninitialized. Can you address that please?

> +TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_PHY,
> handle_channels, "Show available channels.");

Maybe that should be allowed for a CIB_DEV too?

johannes
