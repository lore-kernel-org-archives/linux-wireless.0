Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:51877 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbA2HBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 02:01:50 -0500
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"'Vladimir Kondratiev'" <qca_vkondrat@qca.qualcomm.com>
References: <1422189052-25602-1-git-send-email-dlansky@codeaurora.org> <1422260840.1890.9.camel@sipsolutions.net> <20150126095800.GA12740@w1.fi>
In-Reply-To: <20150126095800.GA12740@w1.fi>
Subject: RE: [PATCH] nl80211: add new scan flag to indicate P2P search
Date: Thu, 29 Jan 2015 09:01:45 +0200
Message-ID: <000801d03b91$73b1c030$5b154090$@codeaurora.org> (sfid-20150129_080153_483691_0FC68677)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Following Jouni's comment, would you please re-consider?

Thanks,
 Dedy.

From: Jouni Malinen [mailto:j@w1.fi] 
Sent: Monday, January 26, 2015 11:58 AM
> On Mon, Jan 26, 2015 at 09:27:20AM +0100, Johannes Berg wrote:
> > On Sun, 2015-01-25 at 14:30 +0200, Dedy Lansky wrote:
> > > Scan request (NL80211_CMD_TRIGGER_SCAN) is used for triggering both 
> > > scan and P2P search.
> > > At driver/firmware layer, scan and P2P search might be handled
differently.
> > > 
> > > Add new scan flag to indicate P2P search. This flag can be used by 
> > > applications (e.g. wpa_supplicant) to explicitly request P2P search.
> > 
> > I think this ship has sailed many months ago -- too late, you can 
> > never rely on wpa_supplicant settings this flag.
> 
> I'm not sure I'd fully agree with that.. wpa_supplicant currently maps its
internal struct wpa_driver_scan_params::p2p_probe to
NL80211_ATTR_TX_NO_CCK_RATE (and also removal of CCK rates from
NL80211_ATTR_SCAN_SUPP_RATES). However, neither of these make much sense in
bands other than 2.4 GHz. There is ongoing effort in defining P2P social
channels on other bands and it would be useful to be prepared for those with
a clear nl80211 flag in scan parameters. P2P on those new bands will require
wpa_supplicant changes, so it is reasonable to assume that a wpa_supplicant
version that supports those bands will also support this new flag.
> 
> > If you need to distinguish, you should be able to advertise P2P-Device 
> > supports, and then get P2P scans on the P2P-Device virtual interface.
> > Could be a pure driver thing of course.
> 
> It would be unfortunate to force people to use P2P-Device for this.
>  
> -- 
> Jouni Malinen                                            PGP id EFC895FA

