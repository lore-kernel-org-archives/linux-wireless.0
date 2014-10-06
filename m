Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41779 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaJFPAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 11:00:46 -0400
Message-ID: <1412607640.3098.33.camel@jlt4.sipsolutions.net> (sfid-20141006_170049_418610_FB9EC8A0)
Subject: Re: [PATCH v2] cfg80211: allow to configure dynamic PS timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 17:00:40 +0200
In-Reply-To: <20141001092710.GB2011@redhat.com>
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com>
	 <542AB859.5080008@broadcom.com> <542AB893.9090201@broadcom.com>
	 <20141001092710.GB2011@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-01 at 11:27 +0200, Stanislaw Gruszka wrote:
> Dynamic power save timeout value is suppose to be configurable via
> wext, but due to iwconfig bug is not possible to set using that tool.

That's interesting, what's that bug?

> Allow to configure PS timeout via nl80211 - add NL80211_ATTR_PS_TIMEOUT
> attribute which become timeout stated in ms.

Why do you want to be able to set it at all though? I remember having
this discussion years ago, and we said that it wasn't really useful
since the user has no idea when and why this should be changed. I'm not
convinced that changed?

We had to keep the wext for compatibility - maybe that can now be
removed if you say it's broken - but I'm not sure I see much value in
adding it (and you're doing nothing to convince me otherwise, so far)

johannes

