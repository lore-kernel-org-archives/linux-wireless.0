Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2DLDiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 23:38:22 -0400
Message-ID: <1334201867.3788.2.camel@jlt3.sipsolutions.net> (sfid-20120412_053854_460489_78AEA3F7)
Subject: Re: [PATCH v3 1/2] cfg80211: add channel switch notify event
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Thu, 12 Apr 2012 05:37:47 +0200
In-Reply-To: <1333744548-18028-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120406_223557_026604_A9DD14C6)
References: <1333744548-18028-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 (sfid-20120406_223557_026604_A9DD14C6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-06 at 13:35 -0700, Thomas Pedersen wrote:

>  /*
> + * cfg80211_ch_switch_notify - update wdev channel and notify userspace
> + * @dev: the device which switched channels
> + * @freq: new channel frequency (in MHz)
> + * @type: channel type
> + *
> + * Acquires wdev_lock, so must only be called from sleepable driver context!
> + */
> +void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
> +			       enum nl80211_channel_type type);

I think this could be a bit more detailed -- the driver authors won't
know what wdev_lock is (nor care), but the other consequence of it is
that the function absolutely must not be called in the context of a
cfg80211 call into the driver.

johannes

