Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:43558 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbaBFN0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 08:26:38 -0500
Received: from smtp02.msg.oleane.net (smtp02.mail.priv [172.17.20.111])
	by smtp-out03.msg.oleane.net with ESMTP id s16DQbbQ010242
	for <linux-wireless@vger.kernel.org>; Thu, 6 Feb 2014 14:26:37 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id s16D6PW2027378
	for <linux-wireless@vger.kernel.org>; Thu, 6 Feb 2014 14:06:25 +0100
Subject: ATH9K software retry
Date: Thu, 6 Feb 2014 14:06:24 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A3190173371A@sbs2003.acksys.local> (sfid-20140206_142643_171188_42E88AAA)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In xmit.c the function ath_tx_complete_aggr test if the fi->retries <
ATH_MAX_SW_RETRIES.

If this condition is true, ATH9K handle software retry. 

Minstrel set in the frame one or more rates, for each rate minstrel set
a retries count. I think is sufficient.

Why ATH9K need to manage the software retries?

With the test we have a minimal of 30 retries (ATH_MAX_SW_RETRIES is set
to 30).

I plan to remove the software retry int ATH9K, before I would like to
know if theses retries is necessary.

	Regards.

Cedric Voncken

