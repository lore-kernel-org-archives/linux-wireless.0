Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2CBHte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 02:49:34 -0500
Subject: Re: [PATCHv2 1/3] mac80211_hwsim:  Add tsf to beacons, probe
 responses and radiotap header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330645207-13964-1-git-send-email-javier@cozybit.com> (sfid-20120302_004046_893849_3F57E248)
References: <1330645207-13964-1-git-send-email-javier@cozybit.com>
	 (sfid-20120302_004046_893849_3F57E248)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 08:49:28 +0100
Message-ID: <1330674568.3367.2.camel@jlt3.sipsolutions.net> (sfid-20120302_085001_650746_1A74B3F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-01 at 15:40 -0800, Javier Cardona wrote:
> Generate a tsf from jiffies.  Prepare the path for having different tsf
> offsets on the each phy.  This will be useful for testing mesh
> synchronization algorithms.

The fact that you used jiffies should have made me wonder earlier :)

> +static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
> +{
> +	return cpu_to_le64(jiffies_to_msecs(jiffies)*1000/1024 +
> +			data->tsf_offset);
> +}

This is not right? TSF is in microseconds, here you're like converting
msec to TU (I think). Also, jiffies doesn't even increase fast enough
for the timestamp, I'm pretty sure you need hrtimers.

johannes

