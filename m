Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2G0LIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:08:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SuiOp-0005z9-5r
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 13:08:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] mac80211: use correct operating channel
Date: Fri, 27 Jul 2012 13:07:55 +0200
Message-Id: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130808_918452_CA9F2092)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of places in mac80211 are erroneously using the
*current* channel (hw.conf.channel) rather than the current
*operating* channel (oper_channel). This is wrong as the
current channel can change during scan/roc and therefore
doesn't point to the correct channel all the time so that
due to races the wrong channel might be used.

Address this and use the correct channel in all places.
Some keep using hw.conf.channel, of course, since they
really do need the current channel.

johannes

