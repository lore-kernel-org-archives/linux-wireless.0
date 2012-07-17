Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2GQKSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 06:18:43 -0400
Message-ID: <1342520320.8139.0.camel@jlt3.sipsolutions.net> (sfid-20120717_121847_088917_27AA6E60)
Subject: Re: [PATCH] mac80211: go out of PS before sending disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Jul 2012 12:18:40 +0200
In-Reply-To: <1342103733-31835-1-git-send-email-eliad@wizery.com> (sfid-20120712_163531_211284_66B44DF3)
References: <1342103733-31835-1-git-send-email-eliad@wizery.com>
	 (sfid-20120712_163531_211284_66B44DF3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 17:35 +0300, Eliad Peller wrote:
> on disassoc, ieee80211_set_disassoc() goes out of PS
> before indicating BSS_CHANGED_ASSOC (not sure why this
> is needed, but some drivers might count on the current
> behavior).
> 
> However, it does it after sending the disassoc
> frame, which results in null-data frame being sent
> (in order to go out of ps) after we were already sent
> the disassoc, which is invalid.
> 
> Fix it by going out of ps before sending the disassoc.

Applied, thanks

johannes

