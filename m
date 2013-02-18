Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3BRWXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:23:51 -0500
Message-ID: <1361226227.8555.55.camel@jlt4.sipsolutions.net> (sfid-20130218_232355_055670_6491B8AD)
Subject: Re: [PATCH v2] iw: add packet offset information for wowlan pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 18 Feb 2013 23:23:47 +0100
In-Reply-To: <1360700187-22806-2-git-send-email-bzhao@marvell.com>
References: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
	 <1360700187-22806-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also...

>  COMMAND(wowlan, enable, "[any] [disconnect] [magic-packet] [gtk-rekey-failure] [eap-identity-request]"
> -	" [4way-handshake] [rfkill-release] [patterns <pattern>*]",
> +	" [4way-handshake] [rfkill-release] [patterns [offset1] <pattern1> ...]",
>  	NL80211_CMD_SET_WOWLAN, 0, CIB_PHY, handle_wowlan_enable,
>  	"Enable WoWLAN with the given triggers.\n"
>  	"Each pattern is given as a bytestring with '-' in places where any byte\n"
>  	"may be present, e.g. 00:11:22:-:44 will match 00:11:22:33:44 and\n"
> -	"00:11:22:33:ff:44 etc.");
> +	"00:11:22:33:ff:44 etc.\n"
> +	"Use ':' for single byte pattern as well, e.g. 18 43: will match '43' "
> +	"after 18 bytes of offset in Rx packet.");

Is there maybe a slightly more intuitive syntax? I'm not really worried
about the break of pattern being just a single byte, but it seems to me
something like <offset>+<pattern> or so would be easier to understand?

iw wowlan enable disconnect patterns 14+88:8E

It would also be more obviously wrong to an old iw version -- it would
reject this, while it would accept "14 88:8E" as two patterns.

johannes

