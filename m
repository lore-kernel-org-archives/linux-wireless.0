Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:42963 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2GDRuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 13:50:11 -0400
Date: Wed, 4 Jul 2012 20:44:21 +0300
From: Jouni Malinen <j@w1.fi>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
Message-ID: <20120704174421.GA6070@w1.fi> (sfid-20120704_195017_537197_4317C765)
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>
 <1341394528.4482.4.camel@jlt3.sipsolutions.net>
 <4FF414D9.4060509@lri.fr>
 <1341396753.4482.13.camel@jlt3.sipsolutions.net>
 <4FF43E53.6050805@lri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF43E53.6050805@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 04, 2012 at 03:00:03PM +0200, Nicolas Cavallari wrote:
> From what i understand, data frames to unauthorized stations are dropped
> well before selecting the encryption key. as stations are authorized
> after or at the same time their encryption key are set, it somewhat
> works. But for MFP, i'm not sure. I think that drop_unencrypted is
> mistaken for "drop_unencrypted_management" there.
> But i'm not an MFP expert.

drop_unencrypted was originally (i.e., way before MFP) added as an extra
protection for some corner cases where keys may not have been set. In
theory, the PAE (authorized vs. unauthorized) should have covered those
cases, but there were some multi-SSID AP cases that were not obviously
clear. Consequently, it felt safer to add an extra protection for BSSes
that are known to use encryption for data frames.

As far as MFP is concerned, we have the WLAN_STA_MFP flag that should be
more reliable way of determining whether robust management frames have
to be protected.

> I'm not sure if we should just add a separate
> drop_unencrypted_management, or just replace drop_unencrypted with
> drop_unencrypted_management.

I hope that neither of those would be needed.

> But in a IBSS with RSN, if wpa_supplicant
> isn't recent enough, stations are always authorized by default. so
> drop_encrypted is required in this case.

For a BSS that uses RSN, we could maintain a new flag that indicates
that (non-nullfunc) Data frames are not to be transmitted or received
without protected. Though, this would be quite similar to
drop_unencrypted in practice.


As far as the new patch is concerned, it would look like this is
extending the fix in commit e0463f501fb945c1fde536d98eefc5ba156ff497.
The commit log for that change seems to claim that the goal was to avoid
dropping any management frames to a STA that does not use MFP, but the
change does not seem to do that.

As far as drop_unencrypted not being used in AP/managed mode is
concerned, that sounds like an additional bug.. This code is supposed to
drop Action frames from STA/AP before 4-way handshake. If we want to get
rid of drop_unencrypted, this function may need another condition to
drop the frame based on WLAN_STA_MFP flag. I have clearly assumed that
drop_unencrypted was set here (and maybe that was indeed the case in
early 2009 or maybe I did testing with WEXT at the time based on commit
0c7c10c7cc6bc890d23c8c62b81b4feccd92124b).

-- 
Jouni Malinen                                            PGP id EFC895FA
