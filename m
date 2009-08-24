Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:54013 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbZHXRY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 13:24:26 -0400
Date: Mon, 24 Aug 2009 19:24:26 +0200
Message-Id: <1779292525@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: =?iso-8859-15?Q?Re:_[Fwd:_[Bug_13725]_p54_gets_a_"tx_refused_but_queue?=
 =?iso-8859-15?Q?_active"_WARNING_from_mac80211]?=
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Christian and Johannes,
> 
> A dongle running p54usb gets a "tx refused but queue active" WARNING
> when used as an AP using hostapd and running 2.6.31-rc6 from Linus's
> tree, even with my patch that fixed this problem in STA mode.
> Christian, have you tested this configuration? Johannes - any thoughts?

well, this particular WARN_ON can probably be fixed by reverting the following patch:
"p54: call p54_wake_free_queues on every p54_free_skb and p54_rx_frame_sent"

however, based on Max commit description this patch is necessary for p54spi to
work properly. So, I'm not going to touch it...

The best thing he can do now is to use compat-wireless.
(Or since he uses a -rc kernel anyway, why not wireless-testing?)
wireless-testing/cw does not only have a newer driver,
but also mac80211 improvements for power-saving clients.
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

