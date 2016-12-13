Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50692 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934104AbcLMQjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:39:32 -0500
Message-ID: <1481645701.20412.39.camel@sipsolutions.net> (sfid-20161213_174012_477721_ECA6AD8A)
Subject: Re: [RFC V3 01/11] nl80211: add reporting of gscan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Date: Tue, 13 Dec 2016 17:15:01 +0100
In-Reply-To: <1481543997-24624-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	case 14:
> +		if (!rdev->wiphy.gscan) {
> +			/* done */
> +			state->split_start = 0;
> +			break;
> +		}
> 

Nit, but I'm not really happy with this - this assumes that case 14 is
the last case, if anyone ever adds one we break this code but it would
still work if the device has gscan. Move the gscan stuff into a new
function and make that return immediately if gscan is NULL or so?

johannes
