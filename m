Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58383 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYHJOTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 10:19:21 -0400
Message-ID: <489EF8DE.5030801@lwfinger.net> (sfid-20080810_161924_653588_2A7037C0)
Date: Sun, 10 Aug 2008 09:19:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808081026.49041.chunkeey@web.de> <489C5833.2080009@lwfinger.net> <200808082038.48840.chunkeey@web.de>
In-Reply-To: <200808082038.48840.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> the next one is at line 27188... and so down to end of packages at line 329241.
> there isn't one single package where the sequence number is not zero!
> 
> So the problem must be somewhere else! what happens when:
> if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> 		priv->seqno += 0x10;
> 
> 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> 	ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> }
> (yeah a new definition for idiotic! but it's about the same amount of of clock cycles).

There must be some situation where the firmware fails to assign a 
proper sequence number to some packets. With this patch in place, the 
device failed after 2 hours. Restoring my original patch, it has been 
up for 15 hours and still going.

Larry

