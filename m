Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2HBUE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 16:04:56 -0400
Message-ID: <1343937886.4471.29.camel@jlt3.sipsolutions.net> (sfid-20120802_220459_114124_70DBC5CA)
Subject: Re: [PATCH] cfg80211: process pending events when unregistering net
 device
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 22:04:46 +0200
In-Reply-To: <20120802174148.536A39D401E@zog.reactivated.net>
References: <20120802174148.536A39D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 18:41 +0100, Daniel Drake wrote:
> libertas currently calls cfg80211_disconnected() when it is being
> brought down. This causes an event to be allocated, but since the
> wdev is already removed from the rdev by the time that the event
> processing work executes, the event is never processed or freed.
> http://article.gmane.org/gmane.linux.kernel.wireless.general/95666
> 
> Fix this leak, and other possible situations, by processing the event
> queue when a device is being unregistered. Thanks to Johannes Berg for
> the suggestion.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

This should probably be Cc: stable too? John, can you pick up the patch,
since I see you already pulled my earlier pull requested?

Cc: stable@vger.kernel.org
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

