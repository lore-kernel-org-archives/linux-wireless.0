Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38720 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872AbaJ2Psg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:48:36 -0400
Message-ID: <1414597712.1827.14.camel@jlt4.sipsolutions.net> (sfid-20141029_164844_175973_CAE47283)
Subject: Re: [PATCH 2/3] mac80211-hwsim: Provide multicast event for
 HWSIM_CMD_NEW_RADIO
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:48:32 +0100
In-Reply-To: <1414406688-3827-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114540_063766_7C3E5B4A)
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414406688-3827-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114540_063766_7C3E5B4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:

> +static void mcast_new_radio(int id, struct genl_info *info,
> +			    int channels, const char *reg_alpha2,
> +			    const struct ieee80211_regdomain *regd,
> +			    bool reg_strict, bool p2p_device,
> +			    bool use_chanctx)

Since you're adding yet another function with all these arguments, maybe
you could split them out into some kind of radio config struct that you
can pass around?

johannes


