Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42686 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdBXGy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:54:27 -0500
Message-ID: <1487918197.2540.1.camel@sipsolutions.net> (sfid-20170224_075431_354119_618C2E8C)
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:36:37 +0100
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com> (sfid-20170224_012921_813683_C1D64839)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012921_813683_C1D64839)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> +			       HWSIM_CMD_NOTIFY);

I think you should use a more specific command name.

> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
> +		    ETH_ALEN, data->addresses[1].addr))
> +		goto nla_put_failure;

and at least also add a more specific identifier like the radio ID.

> +	if (data->channel)
> +		center_freq = data->channel->center_freq;
> +
> +	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, center_freq))
> +		goto nla_put_failure;

and have the full channel definition


Also the indentation in the documentation didn't match the convention
used there.

johannes
