Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2CBVKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:10:20 -0500
Subject: Re: [PATCHv3 1/2] mac80211_hwsim:  Add tsf to beacons, probe
 responses and radiotap header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330722280-28879-1-git-send-email-javier@cozybit.com> (sfid-20120302_220521_770334_56729013)
References: <1330722280-28879-1-git-send-email-javier@cozybit.com>
	 (sfid-20120302_220521_770334_56729013)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 22:10:16 +0100
Message-ID: <1330722616.8542.24.camel@jlt3.sipsolutions.net> (sfid-20120302_221024_373251_6B809240)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 13:04 -0800, Javier Cardona wrote:
> Generate a tsf from jiffies.  Prepare the path for having different tsf
> offsets on the each phy.  This will be useful for testing mesh
> synchronization algorithms.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v2: Added timestamp to probe responses, as suggested by Johannes
>     Also implement tx_last_beacon, useful for testing (new patch 1/3)
> v3: Drop poorly implemented tx_last_beacon patch
>     TSF in microsecs, not TUs!    (Johannes)
>     Use high-resolution timer, not jiffies (Johannes)
 
> +static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
> +{
> +	return cpu_to_le64(jiffies_to_msecs(jiffies)*1000/1024 +
> +			data->tsf_offset);
> +}

Did you forget to quilt refresh or so? :-)

johannes

