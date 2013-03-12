Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45210 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3CLJoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 05:44:13 -0400
Received: by mail-wg0-f51.google.com with SMTP id 8so6005692wgl.30
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 02:44:12 -0700 (PDT)
Date: Tue, 12 Mar 2013 10:41:19 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
Message-ID: <20130312094119.GA23062@magnum.frso.rivierawaves.com> (sfid-20130312_104417_195559_33DCCD0F)
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 10:51:08AM +0100, Felix Fietkau wrote:
> When MCS rates start to get bad in 2.4 GHz because of long range or
> strong interference, CCK rates can be a lot more robust.
> 
> This patch adds a pseudo MCS group containing CCK rates (long preamble
> in the lower 4 slots, short preamble in the upper slots).
> 
With this, mac80211 might send CCK rates with IEEE80211_TX_CTL_AMPDU set.
For aggregates, if we don't currently set NO_CCK, at the very least the
1st rate index should belong to an MCS_GROUP.

 
Karl
