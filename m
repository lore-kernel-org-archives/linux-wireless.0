Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab3BXRWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 12:22:48 -0500
Message-ID: <1361726563.8129.6.camel@jlt4.sipsolutions.net> (sfid-20130224_182258_780439_D2D57F26)
Subject: Re: [RFC 00/13] brcmsmac: add AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Sun, 24 Feb 2013 18:22:43 +0100
In-Reply-To: <5129FBB8.1080505@hauke-m.de> (sfid-20130224_123852_665943_7C5D7E9A)
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
	 <A47087626F2942499CF47E79803E771E0431BF4D@SJEXCHMB13.corp.ad.broadcom.com>
	 <5129FBB8.1080505@hauke-m.de> (sfid-20130224_123852_665943_7C5D7E9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-02-24 at 12:38 +0100, Hauke Mehrtens wrote:

> Yes this needs some review and more testing, I hope this also works with
> power saving stations and so on.

I doubt it will. I know it's not really a major thing, but due to the
way aggregation is handled you definitely need to implement
"release_buffered_frames". "allow_buffered_frames" might not be
necessary if the device doesn't track station's powersave mode by
itself? Not sure how that's supposed to work, too long since I worked on
Broadcom stuff.


> probe response offload

See also enum nl80211_probe_resp_offload_support_attr; probe response
offload is a bit tricky because e.g. for WPS you absolutely need
userspace, not the firmware, to respond. So if the firmware can't tell
the difference between regular and WPS probe requests, you can't support
WPS.

If you can, I'd probably just turn off the response offload. It's likely
not worth the effort. If you wanted to make that turning off conditional
we'd have to come up with a bunch of new API to let the driver know what
kind of AP it's running.

johannes

