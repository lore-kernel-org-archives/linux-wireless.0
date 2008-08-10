Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47421 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYHJWZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 18:25:44 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Mon, 11 Aug 2008 00:27:59 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489EF8DE.5030801@lwfinger.net>
In-Reply-To: <489EF8DE.5030801@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808110027.59918.chunkeey@web.de> (sfid-20080811_002548_220874_4486FE91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 August 2008 16:19:10 Larry Finger wrote:
> Chr wrote:
> > the next one is at line 27188... and so down to end of packages at line
> > 329241. there isn't one single package where the sequence number is not
> > zero!
> >
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
> There must be some situation where the firmware fails to assign a
> proper sequence number to some packets. With this patch in place, the
> device failed after 2 hours. Restoring my original patch, it has been
> up for 15 hours and still going.
well, if you don't ping around with -s 1400 of course ;-).

On the other hand, it doesn't break anything (that wasn't broken before) and 
if real helps, why not?

Acked-by: Christian Lamparter <chunkeey@web.de>
