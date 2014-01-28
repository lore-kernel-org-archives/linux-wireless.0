Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaA1NhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 08:37:19 -0500
Message-ID: <1390916215.4148.5.camel@jlt4.sipsolutions.net> (sfid-20140128_143722_980326_DB15A218)
Subject: Re: [PATCH RESEND mac80211] cfg80211: fix channel configuration in
 IBSS join
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Tue, 28 Jan 2014 14:36:55 +0100
In-Reply-To: <52E7B134.2040404@open-mesh.com>
References: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>
	 <87wqhkgszo.fsf@kamboji.qca.qualcomm.com> <52E7B134.2040404@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-28 at 14:31 +0100, Antonio Quartulli wrote:
> On 28/01/14 14:01, Kalle Valo wrote:
> >> - Patch is getting resent because I did not CC'd the linux-wireless mailing list in
> >> my previous attempt. :)
> > 
> > Oh, I missed that. Anyway, in previous version I  commented about
> > documenting NULL usage. What do you think about that?
> 
> Well documentation is always good :) If it is need I will add it.
> 
> However, I'd rather ask you what ath6kl is trying to do in that case,
> since it's the only driver invoking cfg80211_ibss_joined() with a zero
> BSSID (and now a NULL channel) on IBSS leave.
> 
> From the cfg80211 prospective, that call is seen like a notification of
> being connected to a new BSS having zero mac and NULL channel. I don't
> see how this can be useful at all, also because after leaving the IBSS I
> imagine that no other operation will take place on that vif unless it
> reconnects again.

That seems completely pointless and should probably be removed?

johannes

