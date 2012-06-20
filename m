Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2FTPcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 11:32:45 -0400
Message-ID: <1340206362.4655.73.camel@jlt3.sipsolutions.net> (sfid-20120620_173248_217003_D885E01B)
Subject: Re: [PATCH] mac80211: use the correct capability info in
 ieee80211_set_associated()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 17:32:42 +0200
In-Reply-To: <1340202204-20536-1-git-send-email-coelho@ti.com> (sfid-20120620_162341_295812_9D0560B4)
References: <1340202204-20536-1-git-send-email-coelho@ti.com>
	 (sfid-20120620_162341_295812_9D0560B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 17:23 +0300, Luciano Coelho wrote:
> If an AP is beaconing with different capabilities than the one we get
> in the associate response, we were still using the capabilities
> received in the beacons.  One example is when the AP is beaconing with
> the short slot bit set to zero and then we try to connect to it with
> long slot.  In this case, we would keep using long slot until the next
> beacon was received.
> 
> Fix this by using the correct capability value when calling
> ieee80211_handle_bss_capability().  We were using cbss->capability,
> but we should use the bss_conf->assoc_capability instead.

Applied.

johannes

