Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1KRLP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:15:26 -0500
Subject: Re: [PATCHv3 2/2] iw: add support for NoAck per tid
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321614110-32392-6-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321614110-32392-6-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 12:15:23 +0100
Message-ID: <1321614923.10266.44.camel@jlt3.sipsolutions.net> (sfid-20111118_121529_921108_BCAEFE1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 12:01 +0100, Simon Wunderlich wrote:

> +static int handle_interface_noack_map(struct nl80211_state *state,
> +				      struct nl_cb *cb,
> +				      struct nl_msg *msg,
> +				      int argc, char **argv)
> +{
> +	uint16_t noack_map;
> +	char *end;
> +
> +	if (argc != 1)
> +		return 1;
> +
> +	noack_map = strtoul(argv[0], &end, 16);
> +	if (end != (argv[0] + strlen(argv[0])))
> +		return 1;

if (*end)
	return 1;

:-)

> +	NLA_PUT_U16(msg, NL80211_ATTR_NOACK_MAP, noack_map);
> +
> +	return 0;
> + nla_put_failure:
> +	return -ENOBUFS;
> +
> +}
> +COMMAND(set, noack_map, "<map>",
> +	NL80211_CMD_SET_NOACK_MAP, 0, CIB_NETDEV, handle_interface_noack_map,
> +	"Set the NoAck map for the TIDs. (0x0001 = BE, 0x000e = BK, 0x0030 = VI, 0x00C0 = VO)");

That doesn't seem right -- BE should be 0x9, BK should be 0x6, no?

johannes

