Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3KYQNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:13:13 -0500
Message-ID: <1385395990.4443.41.camel@jlt4.sipsolutions.net> (sfid-20131125_171316_256812_DD7421B3)
Subject: Re: [PATCH 1/2] nl80211/cfg80211: Set VHT Operating mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:13:10 +0100
In-Reply-To: <1385040495-13482-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131121_142830_633495_FBCC9D6D)
References: <1385040495-13482-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131121_142830_633495_FBCC9D6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 14:28 +0100, Marek Kwaczynski wrote:
> This attribuite is needed for setting VHT operating mode in AP mode
> from User Space. This functionality is required when User Space
> received Assoc Reqeust contains VHT Operation Mode Notification
> element.

The spec doesn't call this "VHT operating mode", it just calls it
"operating mode notification" and I believe it is valid even in HT
stations that are "operating mode notification capable". Shouldn't we
thus rename it all? Right now it's pretty obvious, but once VHT is
rolled into 802.11 "proper" it would be somewhat confusing like this, I
think.

> +	if (info->attrs[NL80211_ATTR_VHT_OPMODE]) {
> +		params.vht_opmode_used = 1;

true, not 1

johannes

