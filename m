Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2GIKNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 06:13:08 -0400
Message-ID: <1341828786.4455.31.camel@jlt3.sipsolutions.net> (sfid-20120709_121322_076967_91DDCAFF)
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 09 Jul 2012 12:13:06 +0200
In-Reply-To: <1341826631.4455.24.camel@jlt3.sipsolutions.net> (sfid-20120709_113745_588565_D68A59A8)
References: <1341766968-29570-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120708_190314_897831_DE794B3E) <1341826631.4455.24.camel@jlt3.sipsolutions.net>
	 (sfid-20120709_113745_588565_D68A59A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 11:37 +0200, Johannes Berg wrote:

> > (6) restructure tx-path of all effected drivers
> > Restructure tx-path of all effected drivers to respect new TPC support in
> > mac80211. TPC support is added to mac80211 by restructuring of struct
> > ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
> > to receive struct sta from the stack and respect the new ieee80211_tx_info
> > struct. List of modified driver:
> 
> again, separate these patches.

Oh and I don't mean split it per driver. Just split up the patch into
the logical API evolutions, like first removing the sta pointer and
introducing the tx_control struct. (Where, btw, you lost an important
comment about it being NULL along the way)

johannes

