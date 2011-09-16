Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1IPM6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 08:58:17 -0400
Subject: Re: [RFC 0/5] TDLS support for nl80211/mac80211 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-1-git-send-email-arik@wizery.com> (sfid-20110915_122546_760971_6A6DA1DF)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 (sfid-20110915_122546_760971_6A6DA1DF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 14:58:10 +0200
Message-ID: <1316177890.4130.27.camel@jlt3.sipsolutions.net> (sfid-20110916_145821_747121_86FAAAA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
> This series adds basic kernel-mode TDLS support for nl80211 based drivers.
> It is based in part on patches by Kalyan C. Gaddam, cc-ed here.

I'm not convinced of the design. I don't see anything in the setup
frames that will require creating them in the kernel. If they are data
frames, the supplicant can create them and send them as such, if they
are public action frames we have nl80211 API for that.

> Support is added for peer discovery and data path setup/teardown. More
> advanced features are not implemented. These include QoS/HT, peer PSM,
> peer U-APSD and channel switching.

That will certainly require kernel help, but I don't think it requires
that the setup frames be created in mac80211.

> Notably, this patch-set does not include locking in the data path,
> to switch between AP-based and direct Tx during link setup/tear-down.
> This will be added by a later patch-set, if/when this series is
> accepted. In practice it seems to work quite well without additional
> locking.

That ought to work without locks if you create/destroy the station
entries appropriately?

johannes

