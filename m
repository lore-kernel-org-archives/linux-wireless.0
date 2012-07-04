Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2GDJfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 05:35:33 -0400
Message-ID: <1341394528.4482.4.camel@jlt3.sipsolutions.net> (sfid-20120704_113536_968504_2D94CC7C)
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Wed, 04 Jul 2012 11:35:28 +0200
In-Reply-To: <1341393221-5396-1-git-send-email-cavallar@lri.fr>
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 11:13 +0200, Nicolas Cavallari wrote:
> When drop_unencrypted is enabled and MFP is disabled, non-robust
> management frames for not-yet associated STA are dropped  before
> being transmitted.
> 
> This isn't visible as many management frames sent from  the kernel
> have TX_INTFL_DONT_ENCRYPT set and management frames injected from
> monitor vifs have TX_CTL_INJECTED set, so are never dropped in the
> tx path. But mgmt frames sent from userspace via NL80211_CMD_FRAME
> do not have any of these flags, so are dropped.
> 
> This patch make it accept non-robust management frames,
> but drops non-management frames and robust management frames as usual.
> 
> Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
> 
> ---
> 
> Found this while trying to manage auth  frames in userspace
> on a IBSS RSN network.
> I'm  a bit surprised that drop_unencrypted is disabled both
> in AP and managed mode, but only enabled in IBSS RSN, which
> does not support MFP, yet.

Hmmm. Yes, all this seems a bit messy. Can we clean this up first?

Maybe something like this?
http://p.sipsolutions.net/d68a99dd3d9b1ab1.txt

The whole drop_unencrypted seems strange to start with though...

johannes

