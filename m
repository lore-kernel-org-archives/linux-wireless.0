Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab3BKLsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:48:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rrd-0000e2-Hb
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:48:01 +0100
Message-ID: <1360583279.8738.17.camel@jlt4.sipsolutions.net> (sfid-20130211_124806_569618_74EDF15A)
Subject: Re: [PATCH v2] mac80211: explicitly copy channels to VLANs where
 needed
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:47:59 +0100
In-Reply-To: <1360322072-17239-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_121440_204800_57254D40)
References: <1360322072-17239-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130208_121440_204800_57254D40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 12:14 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently the code assigns channel contexts to VLANs
> (for use by the TX/RX code) when the AP master gets
> its channel context assigned. This works fine, but
> in the upcoming radar detection work the VLANs don't
> require a channel context (during radar detection)
> and assigning one to them anyway causes issues with
> locking and also inconsistencies -- a VLAN interface
> that is added before radar detection would get the
> channel context, while one added during it wouldn't.
> 
> Fix these issues moving the channel context copying
> to a new explicit operation that will not be used
> in the radar detection code.

Applied.

johannes

