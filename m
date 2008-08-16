Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51874 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYHPOfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 10:35:08 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Sat, 16 Aug 2008 16:38:00 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808160421.33375.chunkeey@web.de> <48A6DD7B.4090201@lwfinger.net>
In-Reply-To: <48A6DD7B.4090201@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808161638.01356.chunkeey@web.de> (sfid-20080816_163532_445936_48AEF8A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 16 August 2008 16:00:27 Larry Finger wrote:
> Chr wrote:
> > On Saturday 16 August 2008 02:34:38 Larry Finger wrote:
> >> This one lasted for 4 hours. What was worse is that it crashed my
> >> computer with a 1 Hz blink of the Caps Lock light when it failed. I
> >> hadn't seen that before.
> >
> > hmm,.... sounds like a bit of a old problem with the minipci card...
> > p54_rx_frame_sent walks in the tx_queue without holding the
> > tx_queue.lock.
> >
> > However, this problem is next to impossible to trigger in the current
> > code. So, a crash log from a serial console would be great?
>
> This one locked up the machine. I don't know how long it lasted as it
> was overnight. This time, the caps lock was not blinking, but the only
> recovery was to power it off.
hmm, so the system doesn't respond to sysrq-p.. bad?
one last thing, replace

-	return NETDEV_TX_BUSY;
with
+	return 0;

in p54_tx right at the top... it seems that ieee80211_stop_queue
doesn't work properly.

On the other hand. we might get a new driver, or atleast some
some help with the softmac part from a "company that sells this devices"
in the foreseeable future.

Regards,
	Chr

