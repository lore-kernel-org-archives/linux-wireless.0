Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39574 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYHHKEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 06:04:49 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Fri, 8 Aug 2008 10:26:48 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net>
In-Reply-To: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808081026.49041.chunkeey@web.de> (sfid-20080808_120455_041638_67DE6971)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 August 2008 18:23:16 Larry Finger wrote:
>
> +	/* FIXME: The sequence that follows is needed for this driver to
> +	 * work with mac80211 since "mac80211: fix TX sequence numbers".
> +	 * As with the temporary code in rt2x00, changes will be needed
> +	 * to get proper sequence numbers on beacons. In addition, this
> +	 * patch places the sequence number in the hardware state, which
> +	 * limits us to a single virtual state.
> +	 */
> +	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> +			priv->seqno += 0x10;
> +		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> +		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> +	}
??? 
What is this for? The firmware does the sequence number counting
and will simply override this field without looking at it... Are you sure this
really fixes anything?
 
That said: the firmware will always report the sequence number of every
tx'ed frame as a part of p54_frame_sent_hdr in the _free_ tx callback...

Regards,
	Chr.
