Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2JPSkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:40:31 -0400
Message-ID: <1350412864.10177.9.camel@jlt4.sipsolutions.net> (sfid-20121016_204039_848741_1D0A894F)
Subject: Re: [PATCH] iw: add lowpri and flush scan operands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 16 Oct 2012 20:41:04 +0200
In-Reply-To: <1350346947-21280-1-git-send-email-bzhao@marvell.com>
References: <1350346947-21280-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-15 at 17:22 -0700, Bing Zhao wrote:

> --- a/nl80211.h
> +++ b/nl80211.h

No need to send nl80211.h updates, I do those directly by copying the
new file to avoid mismatch issues.


> -TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]", 0, 0,
> +TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|lowpri|flush]", 0, 0,

This seems a little wrong, you can't give lowpri/flush after giving
SSIDs, so it should probably be written as

... [ies <...>] [lowpri|flush] [ssid ...]

The SSID list has to be last since no keyword can terminate it
(everything could be a valid SSID)

>  	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
>  	 "Trigger a scan on the given frequencies with probing for the given\n"
> +

spurious newline?

johannes

