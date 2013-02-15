Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3BOMPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:15:08 -0500
Message-ID: <1360930499.15040.7.camel@jlt4.sipsolutions.net> (sfid-20130215_131511_894106_7D22F0C6)
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 15 Feb 2013 13:14:59 +0100
In-Reply-To: <1360928446-543-1-git-send-email-marco@cozybit.com> (sfid-20130215_124056_325990_55BC105E)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
	 (sfid-20130215_124056_325990_55BC105E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 12:40 +0100, Marco Porsch wrote:

> -	/* The current tsf is a first approximation for the timestamp
> -	 * for the received beacon.  Further down we try to get a
> -	 * better value from the rx_status->mactime field if
> -	 * available. Also we have to call drv_get_tsf() before
> -	 * entering the rcu-read section.*/

I don't think you should drop this comment; also why not just address
it? There's a timestamp in rx_status that should be the correct one for
ath9k (which is pretty much all this seems to work on anyway :) )

johannes

