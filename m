Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031010Ab2CAOVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:21:11 -0500
Subject: Re: [PATCH] cfg80211: Add an attribute to set inactivity timeout
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1330606339-9055-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1330606339-9055-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 15:21:05 +0100
Message-ID: <1330611665.3623.3.camel@jlt3.sipsolutions.net> (sfid-20120301_152114_781053_2537B593)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 18:22 +0530, Vasanthakumar Thiagarajan wrote:
> This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
> to set the inactivity timeout which can be used to remove the
> station in AP mode. This can be passed in NL80211_CMD_START_AP
> and used by the drivers which have AP MLME in firmware but
> don't support get_station() properly.

Doesn't hostapd need to know whether this is done or not? At least if it
knew it could avoid timers etc. -- seems you should add a flag that
indicates support for this? .And maybe refuse the setting if the flag
isn't set.

johannes


