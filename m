Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0KWDCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 22:02:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
	  <1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 23 Nov 2010 04:02:47 +0100
Message-Id: <1290481367.3070.5.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -        if (ieee80211_is_data_qos(fc)) {
> +        if (ieee80211_is_data_qos(fc) &&
> +               (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {

Isn't skb queue mapping set up already so you could use that?

Johannes
