Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:54827 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbXKVEcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 23:32:14 -0500
Date: Wed, 21 Nov 2007 20:31:56 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: remove "bcn_int" and "capab" scan results
	info
Message-ID: <20071122043156.GB8672@jm.kir.nu> (sfid-20071122_043227_422587_A4CAE53A)
References: <1195664138-21789-1-git-send-email-linville@tuxdriver.com> <1195664475.12000.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195664475.12000.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 21, 2007 at 06:01:15PM +0100, Johannes Berg wrote:
> On Wed, 2007-11-21 at 11:55 -0500, John W. Linville wrote:
> > These bits were dead code before "mac80211: Remove local->scan_flags"
> > (commit 6681dd3fd0e4d36a4547415853e83411baa7b705) and probably should
> > have been removed as part of that commit.
> 
> I'm all for it. But Jouni complained although this code couldn't be
> triggered. I think Jouni's objections will be addressed with nl80211
> work though, so maybe we can remove it for now anyway?

If I understood correctly, the proposed change was removing 'capab'
information from scan results(?). If that is the case, that would break
wpa_supplicant network selection since there would be no information on
whether the network is using encryption or not (privacy flag) and
whether it is a BSS or an IBSS. Consequently, I obviously continue to
object this type of change as long as WE is used for getting scan
results.

-- 
Jouni Malinen                                            PGP id EFC895FA
