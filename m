Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab0LGJlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 04:41:53 -0500
Subject: Re: [PATCH] mwifiex: remove some element ID's definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1291702585-30285-1-git-send-email-bzhao@marvell.com>
References: <1291702585-30285-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 10:41:51 +0100
Message-ID: <1291714911.3607.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-06 at 22:16 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Those are already defined in include/linux/ieee80211.h
> under "enum ieee80211_eid".

Good patch :)

> -	enum ieee_types_elementid_e element_id;
> +	enum ieee80211_eid element_id;

You should probably just use a u8, since that'll match better what the
value really is, it can't have any more values than that and an enum
really is an "int" not a "u8". Also lets you remove the typecasts (that
I don't think are necessary to start with)

>  enum ieee_types_elementid_e {

>  	BSSCO_2040 = 72,
>  	OVERLAP_BSS_SCAN_PARAM = 74,
>  	EXT_CAPABILITY = 127,

I think you should add these remaining ones into the WLAN_EID_ namespace
instead of keeping them.

> +	WPS_IE = WLAN_EID_VENDOR_SPECIFIC,
> +	WMM_IE = WLAN_EID_VENDOR_SPECIFIC,

And these seem just plain misleading since they don't identify
anything ... one could be tempted to use both in a switch() statement
for example. I'd replace their use with just vendor-specific I think
(although I'm aware that some older code we have in the stack does this
as well, IIRC)

johannes

