Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3JALJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:09:21 -0400
Message-ID: <1380625757.14430.22.camel@jlt4.sipsolutions.net> (sfid-20131001_131000_689901_93D78937)
Subject: Re: [PATCH 2/4] nl80211/cfg80211: enable DFS for IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 01 Oct 2013 13:09:17 +0200
In-Reply-To: <1378230201-25446-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1378230201-25446-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 19:43 +0200, Simon Wunderlich wrote:
> To use DFS in IBSS mode, userspace is required to react to radar events.
> It can inform nl80211 that it is capable of doing so by adding a
> NL80211_ATTR_CONTROL_PORT_DFS attribute when joining the IBSS.

I don't like that name, it makes no sense. This has nothing to do with
the port control (802.1X-style) at all.

> If this attribute is supplied, DFS channels may be used if the driver
> supports it. Support will be checked even if a channel without DFS will
> be joined, as the channel might change later due to scan activity or
> channel switch announcements.

You also really should document *what* is required of userspace here.
You're kinda saying this needs to be implemented, but not saying what
needs to be done. I can't even tell - what does it really have to do?
Don't you implement most of it in patches 3 and 4 anyway in the kernel?

johannes

