Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2GaLZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:25:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwAaH-0007HW-7j
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:25:53 +0200
Message-ID: <1343733951.4474.3.camel@jlt3.sipsolutions.net> (sfid-20120731_132557_988407_E7677364)
Subject: Re: [PATCH 0/6] mac80211: use correct operating channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2012 13:25:51 +0200
In-Reply-To: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130808_918452_CA9F2092)
References: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_130808_918452_CA9F2092)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:07 +0200, Johannes Berg wrote:
> A number of places in mac80211 are erroneously using the
> *current* channel (hw.conf.channel) rather than the current
> *operating* channel (oper_channel). This is wrong as the
> current channel can change during scan/roc and therefore
> doesn't point to the correct channel all the time so that
> due to races the wrong channel might be used.
> 
> Address this and use the correct channel in all places.
> Some keep using hw.conf.channel, of course, since they
> really do need the current channel.

All applied.

johannes

