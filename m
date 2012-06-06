Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2FFIlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:41:31 -0400
Message-ID: <1338972090.4513.17.camel@jlt3.sipsolutions.net> (sfid-20120606_104135_826438_44880871)
Subject: Re: [RFC 1/6] mac80211: introduce channel contexts skeleton code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:41:30 +0200
In-Reply-To: <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	 <1337342589-10617-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 14:03 +0200, Michal Kazior wrote:

> +void
> +ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
> +{

Ok one more comment on all these functions -- I'd like to add some
lockdep assertion here or so to make sure we're always protected
correctly. I haven't thought about which lock it needs to be though --
maybe a new one for the channel context stuff?

johannes

