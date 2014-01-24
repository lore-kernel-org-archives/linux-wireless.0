Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaAXPAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:00:05 -0500
Message-ID: <1390575602.4257.44.camel@jlt4.sipsolutions.net> (sfid-20140124_160010_391769_EE834D51)
Subject: Re: [RFC] iw: add support for retry limit
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:00:02 +0100
In-Reply-To: <1389273736-9486-1-git-send-email-royujjal@gmail.com> (sfid-20140109_142238_521185_44E25359)
References: <1389273736-9486-1-git-send-email-royujjal@gmail.com>
	 (sfid-20140109_142238_521185_44E25359)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 18:52 +0530, Ujjal Roy wrote:

Sorry for the late reply.

> @@ -232,6 +232,45 @@ COMMAND(set, rts, "<rts threshold|off>",
>  	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_rts,
>  	"Set rts threshold.");
>  
> +static int handle_retry(struct nl80211_state *state,
> +		      struct nl_cb *cb, struct nl_msg *msg,
> +		      int argc, char **argv,
> +		      enum id_input id)

indentation is a bit off

> +COMMAND(set, retry, "<short limit> [<long limit>]",
> +	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_retry,
> +	"Set retry limit.");

This seems odd to me, why would you want to allow setting the short
limit while not changing the long one, but not the other way around?

johannes

