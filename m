Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50722 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbbKBM1T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 07:27:19 -0500
Message-ID: <1446467233.3205.16.camel@sipsolutions.net> (sfid-20151102_132722_214590_7D6DDE17)
Subject: Re: [RFC] mac80211_hwsim: Implements a check for ATTR_FREQ inside
 hwsim_cloned_frame_received_nl
From: Johannes Berg <johannes@sipsolutions.net>
To: arwelle@cert.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Nov 2015 13:27:13 +0100
In-Reply-To: <1446238820-21004-1-git-send-email-arwelle@cert.org>
References: <1446238820-21004-1-git-send-email-arwelle@cert.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-30 at 17:00 -0400, arwelle@cert.org wrote:
> From: Adam Welle <arwelle@cert.org>
> 
> If a frame is received from netlink with this value set it is checked 
> against the current radio's frequency and discarded if different.

Please line-break the commit log to <=72 characters/line.

> +	/* Check ATTR_FREQ if it exists, and throw away off-channel 
> packets */
> +	if (info->attrs[HWSIM_ATTR_FREQ])
> +		rx_status.freq = nla_get_u32(info
> ->attrs[HWSIM_ATTR_FREQ]);
> +	else
> +		rx_status.freq = data2->channel->center_freq;
> +
> +	/* Drop packet if not on the same frequency as this radio */
> +	if (rx_status.freq != data2->channel->center_freq)
> +		goto out;
> 
I think it'd make sense to have that check only in the case that the
attribute existed. I'm not too concerned about performance here, but
more generally it looks odd if you're checking when you know it can't
be different.

johannes
