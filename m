Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53273 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZGYOLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 10:11:24 -0400
Subject: Re: [PATCH] mac80211: fix receiving deauth
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1248527245.28545.162.camel@violet>
References: <1248515916.19945.1.camel@johannes.local>
	 <1248527245.28545.162.camel@violet>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 16:10:30 +0200
Message-Id: <1248531030.28545.164.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > Marcel reported a warning, which quite obviously comes
> > from an oversight in the code handling deauth frames,
> > and which resulted in multiple follow-up warnings due
> > to this missing handling. This patch adds the missing
> > deauth handling (telling cfg80211 about it) and also
> > removes the follow-up warnings since they could happen
> > due to races even if nothing is wrong. I've explained
> > the races in the comments.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > Reported-by: Marcel Holtmann <marcel@holtmann.org>
> 
> so me current wireless-testing tree now contains the tree from today
> with the oops fix from Luiz, your lockdep fix, Reinette's iwlwifi
> updates and this one. No oopses so far and my connection to the AP stays
> stable. No immediate disconnects anymore. Everything looks good again.

while this fixes the oops and helps with my connect/disconnect issues I
have seen, it doesn't fully fix them. As soon as the AP is something
like more than 5m or 10m away, it connects, disconnects, re-connects
etc. all over again :(

Regards

Marcel


