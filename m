Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1I0LuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:50:11 -0400
Subject: Re: [PATCH 3/5] mac80211: handle TDLS high-level commands and
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1317034493-5300-4-git-send-email-arik@wizery.com> (sfid-20110926_125515_791883_21717CE9)
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
	 <1317034493-5300-4-git-send-email-arik@wizery.com>
	 (sfid-20110926_125515_791883_21717CE9)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:50:07 +0200
Message-ID: <1317124207.4082.20.camel@jlt3.sipsolutions.net> (sfid-20110927_135030_161284_4FC0310B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:

> +/*
> + * TDLS capabililites to be enabled in the 5th byte of the
> + * @WLAN_EID_EXT_CAPABILITY information element
> + */
> +#define WLAN_EXT_CAPA_TDLS_ENABLED	BIT(5)
> +#define WLAN_EXT_CAPA_TDLS_PROHIBITED	BIT(6)

Would it be useful to have the IE declared as a struct somewhere?


> +static int
> +ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
> +			       u8 *peer, u8 action_code, u8 dialog_token,
> +			       u16 status_code, struct sk_buff *skb)

All the code addition here makes me wonder if it'd be useful to move it
into a new tdls.c file and just call the right hooks from cfg.c? the cfg
file is pretty large already ... tdls wouldn't be huge, but still might
make sense?

johannes

