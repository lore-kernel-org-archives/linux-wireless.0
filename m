Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:46263 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYHIQky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2008 12:40:54 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Sat, 9 Aug 2008 18:43:41 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489DBFA9.80608@lwfinger.net>
In-Reply-To: <489DBFA9.80608@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808091843.41985.chunkeey@web.de> (sfid-20080809_184109_209459_D424F7F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 August 2008 18:02:49 Larry Finger wrote:
>
> Mine also crashes with a ping of length 1400, but 1390 and 1410 work
> just fine. I also tested with tcpperf and I am pretty sure that this
> is a transmit problem. When I set the MTU to 1300, then a ping of
> length 1400 works fine. Is this a firmware bug? Which firmware are you
> using? Mine is isl3887usb_bare.
hmm? there are lots of new & old firmwares. 
what chip do you have? a ISL3886 + net2280 or a ISL3887?
you can get the firmware version from dmesg, just load the
driver and grep for "p54: FW rev"

my devices: 
isl3880 minipci: 2.7.0.0 (best supported) & 2.13.1.0 (unstable)
isl3887 usb: 2.5.8.0(bugs), 2.6.16.0(DELL bugs) and 2.13.2.0 (WIP) 

>
> > on-topic: I digged a bit in the logs:
> >
> > http://jbnote.free.fr/prism54usb/data/usbsnoop-logs/
> > and there "usbsnoop_old_drv_ver1.log.bz2"
> > [...]
> > So the problem must be somewhere else! what happens when:
> > if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> > 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> > 		priv->seqno += 0x10;
> >
> > 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> > 	ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> > 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> > }
> > (yeah a new definition for idiotic! but it's about the same amount of of
> > clock cycles).
>
> This didn't help the "ping -s 1400" problem.
Of course not, but maybe it could help with this 2-3 hour disconnect problem.

Regards, 
	Chr.
