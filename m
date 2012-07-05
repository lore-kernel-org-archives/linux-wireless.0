Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GEHze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:55:34 -0400
Message-ID: <1341474929.4455.10.camel@jlt3.sipsolutions.net> (sfid-20120705_095538_368106_1160160E)
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 05 Jul 2012 09:55:29 +0200
In-Reply-To: <20120704174421.GA6070@w1.fi>
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>
	 <1341394528.4482.4.camel@jlt3.sipsolutions.net> <4FF414D9.4060509@lri.fr>
	 <1341396753.4482.13.camel@jlt3.sipsolutions.net> <4FF43E53.6050805@lri.fr>
	 <20120704174421.GA6070@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 20:44 +0300, Jouni Malinen wrote:

> drop_unencrypted was originally (i.e., way before MFP) added as an extra
> protection for some corner cases where keys may not have been set. In
> theory, the PAE (authorized vs. unauthorized) should have covered those
> cases, but there were some multi-SSID AP cases that were not obviously
> clear. Consequently, it felt safer to add an extra protection for BSSes
> that are known to use encryption for data frames.

Hmm, ok.

> As far as MFP is concerned, we have the WLAN_STA_MFP flag that should be
> more reliable way of determining whether robust management frames have
> to be protected.

Right.

> > But in a IBSS with RSN, if wpa_supplicant
> > isn't recent enough, stations are always authorized by default. so
> > drop_encrypted is required in this case.
> 
> For a BSS that uses RSN, we could maintain a new flag that indicates
> that (non-nullfunc) Data frames are not to be transmitted or received
> without protected. Though, this would be quite similar to
> drop_unencrypted in practice.
> 
> 
> As far as the new patch is concerned, it would look like this is
> extending the fix in commit e0463f501fb945c1fde536d98eefc5ba156ff497.
> The commit log for that change seems to claim that the goal was to avoid
> dropping any management frames to a STA that does not use MFP, but the
> change does not seem to do that.

Yeah, it's a bit confusing, especially since the drop_unencrypted is in
there.

> As far as drop_unencrypted not being used in AP/managed mode is
> concerned, that sounds like an additional bug.. This code is supposed to
> drop Action frames from STA/AP before 4-way handshake. If we want to get
> rid of drop_unencrypted, this function may need another condition to
> drop the frame based on WLAN_STA_MFP flag. I have clearly assumed that
> drop_unencrypted was set here (and maybe that was indeed the case in
> early 2009 or maybe I did testing with WEXT at the time based on commit
> 0c7c10c7cc6bc890d23c8c62b81b4feccd92124b).

It looks a bit it got lost years ago in commit
f21293549f60f88c74fcb9944737f11048896dc4, but I can't tell you why. We
also never added nl80211 API for it. Did we just miss it?

I guess what we should do now is figure out what should be going on, do
we even need drop_unencrypted still or are we ok with only MFP?

johannes

