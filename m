Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56870 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYJRVAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 17:00:16 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3 v2] p54: put broadcast frames into the right queues
Date: Sat, 18 Oct 2008 23:04:29 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
References: <200810170115.38317.chunkeey@web.de> <200810170354.25392.chunkeey@web.de> <1224332511.6324.3.camel@johannes.berg>
In-Reply-To: <1224332511.6324.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810182304.29734.chunkeey@web.de> (sfid-20081018_230019_501284_8C34C3E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 October 2008 14:21:51 Johannes Berg wrote:
> On Fri, 2008-10-17 at 03:54 +0200, Christian Lamparter wrote:
> 
> > +	case NL80211_IFTYPE_AP:
> > +		if (is_multicast_ether_addr(hdr->addr1)) {
> > +			*aid = 0;
> > +			*queue = 3;
> > +			return 0;
> > +		}
> 
> Are you sure this is right? I think you should use the mac80211 flag
> IEEE80211_TX_CTL_SEND_AFTER_DTIM maybe?

Ack will post updated patches.

> Also, there's a flag for IEEE80211_TX_CTL_ASSIGN_SEQ (inverted in
> firmware) that you should use.
?

[PATCH 1/3] p54: more definitions form lmac_longbow.h and pda.h
adds in p54_tx(xyz): 
+       if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+               hdr_flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
+
+       /* TODO: enable bursting */
+       hdr->flags = cpu_to_le16(hdr_flags);

Regards,
	Chr
