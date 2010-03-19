Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:6745 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0CSJtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 05:49:45 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: Re: [PATCH 1/1] mac80211: Add support connection monitor in hardware
Date: Fri, 19 Mar 2010 10:51:09 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1268975693-4329-1-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268975693-4329-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201003191051.09596.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The wl1271 has a feature which handles the connection monitor logic
> in hardware, basically sending periodically nullfunc frames and reporting
> to the host if AP is lost, after attempting to recover by sending
> probe-requests to the AP.

Hmm, do you really need to make it configurable?

* works the wl1271 firmware better with this set?
* or better when unset?
* or is it a "depends on" type answer?

As far as I understood you, it works better if the firmware detects the 
connection loss and when mac80211 doesn't interfere. If this understanding is 
true, then configuring this via nl80211 seems to be the wrong thing. Instead, 
you should tell mac80211 about your wishes when registering your driver 
against mac80211.
