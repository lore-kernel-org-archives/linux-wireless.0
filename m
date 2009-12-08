Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37328 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbZLHDzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 22:55:21 -0500
Received: by bwz27 with SMTP id 27so4098734bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 19:55:26 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Dec 2009 22:55:26 -0500
Message-ID: <c4d76b3b0912071955y25c31a11m104d9c4723ef578d@mail.gmail.com>
Subject: cfg80211 connect for at76c50x-usb
From: Jason Andryuk <jandryuk@gmail.com>
To: johannes@sipsolutions.net
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I am unable to connect to my AP with at76c50x-usb.  I believe the
cause is at76c50x-usb and mac80211 trying to send separate auth and
assoc packets to an AP.  Unfortunately the packets for these commands,
while sent over USB to the device, are not actually transmitted.  My
understanding is prior to joining a network, packet transmission is
block.  However, there is a USB command, CMD_JOIN, for connecting to
wireless networks.  Kalle, please correct me if I am wrong on any
details.

CMD_JOIN is a good mapping for cfg80211_ops connect.  The complication
is that at76c50x-usb inherits mac80211_config_ops and there does not
seem to be a way to disable auth and assoc in addition to overriding
connect.

Have you thought about such functionality and do you have any ideas
about how it would (or should) be implemented?

Thanks,

Jason
