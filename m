Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab3ADNFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 08:05:34 -0500
Message-ID: <1357304757.11302.4.camel@jlt4.sipsolutions.net> (sfid-20130104_140537_644580_46369078)
Subject: Re: [PATCH v2 4/4] mac80211_hwsim: streamline beacon timestamp
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, j@w1.fi, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Fri, 04 Jan 2013 14:05:57 +0100
In-Reply-To: <1357167319-13338-4-git-send-email-thomas@cozybit.com> (sfid-20130102_235600_823942_0F811DEB)
References: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
	 <1357167319-13338-4-git-send-email-thomas@cozybit.com>
	 (sfid-20130102_235600_823942_0F811DEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 14:55 -0800, Thomas Pedersen wrote:

> @@ -359,6 +359,8 @@ struct mac80211_hwsim_data {
>  	/* difference between this hw's clock and the real clock, in usecs */
>  	s64 tsf_offset;
>  	s64 bcn_delta;
> +	/* absolute beacon transmission time. Used to cover up "tx" delay. */
> +	u64 abs_bcn_tstamp;

This can't work if you have multiple interfaces, as far as I can tell.

> +		/*
> +		 * Account for delay from filling in the timestamp to mactime.
> +		 */
> +		now = mac80211_hwsim_get_tsf_raw();
> +		if (ieee80211_is_beacon(hdr->frame_control) ||
> +		    ieee80211_is_probe_resp(hdr->frame_control))
> +			now -= now - data->abs_bcn_tstamp;

Uhh. 
	now -= now - data->abs_bcn_tstamp;
<=>	now = now - now + data->abs_bcn_tstamp;
<=>	now = dat->abs_bcn_tstamp;

No? But it seems to me that you're trying to timestamp based on the
transmitter? This is weird anyway? 

johannes

