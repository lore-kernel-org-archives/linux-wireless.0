Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0DLJGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 05:06:21 -0400
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Yl=E4lehto?= Janne Jouko
	<janne.ylalehto@nokia.com>
In-Reply-To: <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271061120.3877.6.camel@jlt3.sipsolutions.net>
	 <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 11:06:15 +0200
Message-ID: <1271063175.3877.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 11:56 +0300, Juuso Oikarinen wrote:

> We could obviously do that. This patch does not prevent adding
> functionality ;)

Well yeah but why let userspace make arbitrary decisions? :)

> For desktops, obviously reduced latency is desirable, while increased
> power consumption is not so much of an issue. For hand-held devices the
> situation is often the opposite: in many situations we might want to
> sacrifice some latency just to stretch the battery life that last inch
> longer, possibly depending on the type of traffic we know we have going
> on.

I don't think this contradicts each other. And we can also factor in the
network_latency pm_qos value. Keep in mind that the gain from the
timeout goes down as it increases past the beacon interval.

In some sense I think it would be smarter to implement a gradual
powersave policy where the device first still wakes up for every beacon
and only later goes down to waking up for DTIM only (which may or may
not be the same ...)

johannes

