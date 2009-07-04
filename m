Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:60856 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZGDQkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 12:40:00 -0400
Message-ID: <4A4F85EE.5090007@lwfinger.net>
Date: Sat, 04 Jul 2009 11:40:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de> <4A4EBB68.6050502@lwfinger.net> <200907041211.49115.chunkeey@web.de>
In-Reply-To: <200907041211.49115.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> hmm, is it possible for you to log the usb transfer?
> A excellent tool for this is usbmon (userspace)... can be found here: 
> 	http://git.sipsolutions.net/usbmon.git
> 
> usbmon -s 3000 -i $(USB_ID) (which is usually number between 1 and the amount of connected usb devices))  > dst
> 
> and set p54common nohwcrypt=1, if you don't want to show GK/TK around ;-)

I have logged the usb transfers, but not yet analyzed them. This time
I got a new failure - I hit this warning at
           net/mac80211/tx.c:1299
                        retries++;
                        if (WARN(retries > 10, "tx refused but queue
active\n"))
                                goto drop;
                        goto retry;


If I have analyzed this correctly, I hit this section of
p54_tx_qos_accounting_alloc at drivers/net/wireless/p54/txrx.c:204.
I'm running the splitup patches.

        if (unlikely(queue->len > queue->limit &&
IS_QOS_QUEUE(p54_queue))) {
                spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
                return -ENOSPC;
        }

Any suggestions on debugging this would be appreciated.

Larry

