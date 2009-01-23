Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33131 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbZAWFqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:46:04 -0500
Message-ID: <49795991.40507@lwfinger.net> (sfid-20090123_064610_766714_C12678F8)
Date: Thu, 22 Jan 2009 23:45:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Gordon, Charles" <Charles.Gordon@digi.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on tx field of struct ieee80211_ops
References: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com> <8DCC153EAFE67A4B990A840E829F704B010A451E5DEF@mtk-sms-exch01.digi.com>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B010A451E5DEF@mtk-sms-exch01.digi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gordon, Charles wrote:
> A follow up question on this is if my transmit routine does not have its own queue and the H/W can only transmit 1 packet at a time, should the transmit routine call ieee80211_stop_queue() when it starts the transmit procedure, and then call ieee80211_wake_queue() when the hardware indicates it has finished transmitting the packet.

I'm not an expert on mac80211, but if you look at the code in
drivers/net/wireless/rtl818x/rtl8187_dev.c, you will see that they TX
packets are not queued by the driver. When the tx ops routine is
called, the data is processed as required and the packet is sent on to
the hardware. In the callback routine, certain status information is
filled in and ieee80211_tx_status_irqsafe() is called to finish the
transaction. You only need to worry about protecting the private data
from concurrent access.

Larry
