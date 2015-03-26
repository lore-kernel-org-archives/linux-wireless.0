Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:49495 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbCZNiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 09:38:04 -0400
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out04.msg.oleane.net with ESMTP id t2QDbrYu027992
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 14:37:54 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id t2QDHUhM002892
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 14:17:31 +0100
Subject: [mac80211]synchronize_net call in ieee_tx_ba_session_handle_start
Date: Thu, 26 Mar 2015 14:17:18 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319019FF102@sbs2003.acksys.local> (sfid-20150326_143808_740496_6ABC8BB2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The synchronize_net called in function ieee_tx_ba_session_handle_start
generate a jiter after the association. I can observe a long period
(100ms or more) where no data are sent because mac80211 is blocked in
synchronize_net.

My product has several network interface and processor with 4 cores.

If I understood correctly, in case we use the ath9k driver, the function
drv_ampdu_action will call the ath_tx_aggr_start and this function will
flush the tx pending packet and return the next sequence number. So in
this case it is not necessary to call this function.

Is it possible to remove this function, or I need to consider another
case?

Thanks for your help.

Cedric Voncken.

