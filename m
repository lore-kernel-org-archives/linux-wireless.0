Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1IUQhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 12:37:43 -0400
Subject: client powersave is completely broken on ath9k and similar HW
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 18:37:39 +0200
Message-ID: <1316623059.3940.54.camel@jlt3.sipsolutions.net> (sfid-20110921_183809_111259_04994434)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwconfig wlan0 power timeout 0
iwconfig wlan0 power off
iwconfig wlan0 power on

=> observe that power saving stays disabled forever

Last little bit of http://paste.pocoo.org/raw/479987/ seems to make it
work somewhat, but is then still completely broken when timeout is >0
due to the abuse of the dynps timer/work to process tx status:

Clearly this is completely messed up. Somebody is going to need to pay
back all the technical debt accumulated here and rewrite it all.

johannes

