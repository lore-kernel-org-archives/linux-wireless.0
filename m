Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1KRLM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:12:29 -0500
Subject: Re: [PATCHv3 3/3] mac80211: Add NoAck per tid Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 12:12:24 +0100
Message-ID: <1321614744.10266.37.camel@jlt3.sipsolutions.net> (sfid-20111118_121232_476384_F328D587)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 12:01 +0100, Simon Wunderlich wrote:

> -		if (is_multicast_ether_addr(hdr->addr1))
> +		if (is_multicast_ether_addr(hdr->addr1) ||
> +			(sdata->noack_map & 1 << tid)) {

I'd prefer this:

		if (is_multicast_ether_addr(...) ||
		    sdata->noack_map & BIT(tid))

(Note indentation & use of BIT())

Isn't this missing an update to ieee80211_duration() now?

johannes

