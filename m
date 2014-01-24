Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaAXOHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 09:07:30 -0500
Message-ID: <1390572447.4257.43.camel@jlt4.sipsolutions.net> (sfid-20140124_150733_805654_B54F0AE6)
Subject: Re: [PATCH] cfg80211: set preset_chandef after channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Jan 2014 15:07:27 +0100
In-Reply-To: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140124_142936_087909_DB42CC45)
References: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140124_142936_087909_DB42CC45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 14:29 +0100, Janusz Dziedzic wrote:
> Set preset_chandef in channel switch notification.
> In other case we will have old preset_chandef.

Why would we care? We only keep the preset_chandef thing around because
hostapd (currently) doesn't pass the frequency to START_AP/the first
SET_BEACON, but after that this doesn't matter. And when you shut down
hostapd, and restart it, then it'll set the preset_chandef again through
explicitly setting the channel.

So in which case would we care? Who would ever STOP_AP and then START_AP
without a new frequency?

johannes

