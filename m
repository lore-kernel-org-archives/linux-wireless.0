Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3BNRaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:30:20 -0500
Message-ID: <1360863015.8210.5.camel@jlt4.sipsolutions.net> (sfid-20130214_183031_204039_B82CDBD3)
Subject: Re: [PATCH] mac80211: don't call bss_info_changed on
 p2p-device/monitor
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: chaitanya.mgit@gmail.com
Date: Thu, 14 Feb 2013 18:30:15 +0100
In-Reply-To: <1360760572-28364-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_140303_577453_12828F58)
References: <1360760572-28364-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130213_140303_577453_12828F58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 14:02 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since the idle decision rework, mac80211 started calling
> bss_info_changed() for the driver's monitor interface,
> which causes a crash for iwlwifi, but drivers generally
> don't expect this to happen. Therefore, avoid it.
> 
> While at it, also prevent calling it in such cases and
> only print a warning. For the P2P Device interface the
> idle will no longer be called (no channel context), so
> also prevent that and warn on it.

Applied.

johannes

