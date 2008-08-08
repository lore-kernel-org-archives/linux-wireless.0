Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:51863 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYHHSgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 14:36:03 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Fri, 8 Aug 2008 20:38:48 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808081026.49041.chunkeey@web.de> <489C5833.2080009@lwfinger.net>
In-Reply-To: <489C5833.2080009@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808082038.48840.chunkeey@web.de> (sfid-20080808_203607_127922_DA9C5F80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 August 2008 16:29:07 Larry Finger wrote:
> Chr wrote:
> > ???
> > What is this for? The firmware does the sequence number counting
> > and will simply override this field without looking at it... Are you sure
> > this really fixes anything?
> >
> > That said: the firmware will always report the sequence number of every
> > tx'ed frame as a part of p54_frame_sent_hdr in the _free_ tx callback...
>
> Without this patch, my p54usb would go offline every 2-3 hours. To recover,
> the driver had to be unloaded and reloaded. With it, the device has never
> gone offline for as long as I have tested. I have no idea what the firmware
> does, but it has helped my system.

well, since I got the usb device I had nothing but problems with it.
e.g: one single ping -s 1400 $AP can bring it down and a _replug_ is necessary.
The minipci card on the other hand is very stable.

I guess p54usb needs some mutexes & udelays here & there.

on-topic: I digged a bit in the logs:

http://jbnote.free.fr/prism54usb/data/usbsnoop-logs/
and there "usbsnoop_old_drv_ver1.log.bz2"

you can easily find tx' data frames by searching for
"00000010: 10 40" string.

to cut the case here is a extract (only ieee 80211 header @line 26218)
08 01 <= frame control
00 00 <= duration ZERO
00 06 25 bb 9d 4b <= mac
00 0f 66 17 46 6b <= mac
ff ff ff ff ff ff <= mac
00 00 <= sequence ZERO
aa aa 03 <= 802.2 LLC header

the next one is at line 27188... and so down to end of packages at line 329241.
there isn't one single package where the sequence number is not zero!

So the problem must be somewhere else! what happens when:
if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
		priv->seqno += 0x10;

	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
	ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
}
(yeah a new definition for idiotic! but it's about the same amount of of clock cycles).

Regards,
	Chr
