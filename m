Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0LNHPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:15:19 -0500
Subject: Re: [PATCH] nl80211: Add notification for dropped Deauth/Disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101213220048.GA24752@jm.kir.nu>
References: <20101213220048.GA24752@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 08:15:07 +0100
Message-ID: <1292310907.3569.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-14 at 00:00 +0200, Jouni Malinen wrote:

> + * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
> + *	notification. This event is used to indicate that an unprotected
> + *	deauthentication frame was dropped when MFP is in use.
> + * @NL80211_CMD_UNPROT_DISASSOCIATE: Unprotected disassociation frame
> + *	notification. This event is used to indicate that an unprotected
> + *	disassociation frame was dropped when MFP is in use.
> + *

I don't mind, but if we add the frame body should we really have two
commands? Or should we have just one? Are we likely to need similar
functionality for other frames? The only ones I can think of are class 3
frames from unassociated stations, but that seems like it should be
separate anyway.

johannes

