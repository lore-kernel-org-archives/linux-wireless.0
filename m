Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0JHOqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 10:46:25 -0400
Subject: Re: [PATCH] iw: new command to set the wds peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1286548659-22176-1-git-send-email-bjordan@rajant.com>
References: <1286441799.3657.29.camel@jlt3.sipsolutions.net>
	 <1286548659-22176-1-git-send-email-bjordan@rajant.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 16:46:23 +0200
Message-ID: <1286549183.3612.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 10:37 -0400, Bill Jordan wrote:
> Add command to set the wds peer bssid using the newly
> implemented NL80211_CMD_SET_WDS_PEER.

applied, thanks

> Signed-off-by: Bill Jordan <bjordan@rajant.com>
> ---
>  interface.c |   31 +++++++++++++++++++++++++++++++
>  nl80211.h   |    3 +++
>  2 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/interface.c b/interface.c
> index a64015f..2dd43e3 100644
> --- a/interface.c
> +++ b/interface.c
> @@ -383,3 +383,34 @@ static int handle_interface_4addr(struct nl80211_state *state,
>  COMMAND(set, 4addr, "<on|off>",
>  	NL80211_CMD_SET_INTERFACE, 0, CIB_NETDEV, handle_interface_4addr,
>  	"Set interface 4addr (WDS) mode.\n");
> +
> +static int handle_interface_wds_peer(struct nl80211_state *state,
> +				    struct nl_cb *cb,
> +				    struct nl_msg *msg,
> +				    int argc, char **argv)
> +{
> +	unsigned char mac_addr[ETH_ALEN];
> +
> +	if (argc < 1)
> +		return 1;
> +
> +	if (mac_addr_a2n(mac_addr, argv[0])) {
> +		fprintf(stderr, "invalid mac address\n");
> +		return 2;
> +	}
> +
> +	argc--;
> +	argv++;
> +
> +	if (argc)
> +		return 1;
> +
> +	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
> +
> +	return 0;
> + nla_put_failure:
> +	return -ENOBUFS;
> +}
> +COMMAND(set, peer, "<MAC address>",
> +	NL80211_CMD_SET_WDS_PEER, 0, CIB_NETDEV, handle_interface_wds_peer,
> +	"Set interface wds peer.\n");
> diff --git a/nl80211.h b/nl80211.h
> index f0518b0..35a9681 100644
> --- a/nl80211.h
> +++ b/nl80211.h
> @@ -387,6 +387,8 @@
>   *	of any other interfaces, and other interfaces will again take
>   *	precedence when they are used.
>   *
> + * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -489,6 +491,7 @@ enum nl80211_commands {
>  	NL80211_CMD_NOTIFY_CQM,
>  
>  	NL80211_CMD_SET_CHANNEL,
> +	NL80211_CMD_SET_WDS_PEER,
>  
>  	/* add new commands above here */
>  


