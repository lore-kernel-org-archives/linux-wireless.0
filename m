Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FLTLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:11:45 -0400
Message-ID: <1339528302.4531.14.camel@jlt3.sipsolutions.net> (sfid-20120612_211148_455550_CFAA0EF1)
Subject: RE: [PATCH 3/4] mwifiex: add 11n support for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 12 Jun 2012 21:11:42 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A7F11AD@SC-VEXCH1.marvell.com>
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	 <1339463659-10736-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120612_031449_661395_EE5E9722) <1339502065.4531.3.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A7F11AD@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 11:44 -0700, Bing Zhao wrote:
> Hi Johannes,
> 
> Thanks for your comment.
> 
> > > Parse HT IE from cfg80211 and set HT capabilities accordingly
> > > to FW. If HT IE is missing, 11n would be disabled in FW.
> > 
> > No objections, but it might be worthwhile to extend the APIs to not
> have
> > to parse this?
> 
> If I understand it correctly, we can probably do something like this:
> 
> 1) add new variables "const u8 *ht_cap" and "size_t ht_cap_len" to
> struct cfg80211_ap_settings
> 2) parse WLAN_EID_HT_CAPABILITY in nl80211_start_ap() and update
> ht_cap/ht_cap_len accordingly
> 3) drivers (mwifiex, etc.) make use of ht_cap/ht_cap_len directly in
> start_ap() handler
> 
> Regardless we have to parse HT_CAP IE from beacon.tail, either in
> driver start_up handler, or inside of cfg80211/nl80211. Please let me
> know if above change is OK for you.

I don't think I'd bother doing the above change. I was thinking that the
supplicant/hostapd would give it in separate attributes, but I guess it
doesn't.

johannes

