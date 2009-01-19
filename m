Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12905 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZASIw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 03:52:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 00:52:57 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18804.16004.937429.850079@gargle.gargle.HOWL> (sfid-20090119_095301_705066_D7613ACF)
Date: Mon, 19 Jan 2009 14:19:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Reconfigure beacons after a merge run in	IBSS
 mode
In-Reply-To: <1232353772.3799.1.camel@johannes>
References: <18804.11602.400684.88722@gargle.gargle.HOWL>
	<1232353772.3799.1.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I think instead we should have an enable-beacon flag that we disable
> before scanning, and then re-enable after scanning like here. That way,
> we also don't need any extra code in the driver to stop beaconing before
> scanning, and it generally helps too when userspace deletes the beacon
> we stop beaconing in a controlled fashion.

Yep, I did remember the earlier discussion, this seemed like a quick fix
for my IBSS troubles :)

> The best way is probably to add a conf flag like CONF_PS and a change
> flag for this, what do you think?

This has to be a per-interface flag, so it would be part of ieee80211_if_conf ?

Sujith
