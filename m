Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59558 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbeITBc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:32:27 -0400
Message-ID: <1537386768.10305.72.camel@sipsolutions.net> (sfid-20180919_215303_156242_DFA7E9C6)
Subject: Re: [PATCH v2 3/5] netlink: move extack setting into validate_nla()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Date: Wed, 19 Sep 2018 21:52:48 +0200
In-Reply-To: <20180919194905.16462-4-johannes@sipsolutions.net> (sfid-20180919_214938_218448_122CE2E9)
References: <20180919194905.16462-1-johannes@sipsolutions.net>
         <20180919194905.16462-4-johannes@sipsolutions.net>
         (sfid-20180919_214938_218448_122CE2E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 21:49 +0200, Johannes Berg wrote:
> 
>  	case NLA_REJECT:
> -		if (pt->validation_data && error_msg)
> -			*error_msg = pt->validation_data;
> +		NL_SET_BAD_ATTR(extack, nla);
> +		if (extack && pt->validation_data)
> +			 extack->_msg = pt->validation_data;
>  		return -EINVAL;

Damn. This of course needs to happen only if pt->validation_data is set,
otherwise it needs to "goto out_err" to set the default message.

I'll respin another day with that fixed, and any other comments that
come in until then addressed.

Sorry for the noise :-(

johannes
