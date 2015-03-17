Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53182 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbbCQKAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:00:54 -0400
Message-ID: <1426586451.1985.2.camel@sipsolutions.net> (sfid-20150317_110100_863661_087B3819)
Subject: Re: [PATCH] mac80211: initialize rate control earlier for tdls
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 11:00:51 +0100
In-Reply-To: <1425830662-24803-1-git-send-email-arik@wizery.com> (sfid-20150308_170427_486026_D613534C)
References: <1425830662-24803-1-git-send-email-arik@wizery.com>
	 (sfid-20150308_170427_486026_D613534C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-08 at 18:04 +0200, Arik Nemtsov wrote:
> From: Marek Puzyniak <marek.puzyniak@tieto.com>
> 
> Currently when TDLS station in driver goes from authorized

from authenticated

> to associated state it can not use rate control parameters
> because rate control is not initialized yet. Some drivers
> require parameters already initialized by rate control when
> entering associated state. It can be done by initializing
> rate control after station transition to associated state
> but before notifying driver about that.

Applied, with the minor fix in the commit log above and the comment in
the code.

johannes

