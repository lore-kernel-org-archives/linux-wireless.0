Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58755 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbE1JqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 05:46:20 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH next 0/2] net: rfkill: gpio: make better use of gpiod API
Date: Thu, 28 May 2015 11:46:11 +0200
Message-Id: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de> (sfid-20150528_114623_257610_6668459C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

this series adapts the rfkill-gpio driver to make use of the flags
parameter of the gpiod_get* family of functions. Currently this is
optional (with a crude cpp hack) but this should change.

The second patch was split out because it probably makes davem break out
in spots. Still I send it because I consider it a sensible change. Up to
you if you want the discussion. (See
http://mid.gmane.org/20150331.140700.1574593248925827837.davem@davemloft.net
for a similar previous discussion.) For other subsystems I did similar
changes in a single patch without any resulting criticism.

Best regards
Uwe

Uwe Kleine-König (2):
  net: rfkill: gpio: make better use of gpiod API
  net: rfkill: gpio: simplify code flow

 net/rfkill/rfkill-gpio.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

-- 
2.1.4

