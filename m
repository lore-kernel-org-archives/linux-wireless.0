Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:40737 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2KYTjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 14:39:16 -0500
Date: Sun, 25 Nov 2012 20:39:10 +0100
From: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: Multi-bss operation issue with rt2x00 and hostapd on rt305x
	platform
Message-ID: <20121125193910.GR8292@ibawizard.net> (sfid-20121125_203919_312565_6EBF20CA)
Reply-To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
References: <20121125190019.GQ8292@ibawizard.net> <1353871018.9875.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <1353871018.9875.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> [2012-11-25 20:16:58]:

> On Sun, 2012-11-25 at 20:00 +0100, Petr ©tetiar wrote:
> 
> > 	nl80211: CMD_FRAME freq=2457 wait=0 no_cck=0 no_ack=0 offchanok=0
> > 	nl80211: Frame TX command accepted; cookie 0x81937c00
> > 	Add randomness: count=39 entropy=38
> > 	nl80211: Event message available
> > -->	nl80211: MLME event 60 (NL80211_CMD_REGISTER_FRAME)
> 
> That command string is wrong. 60 really is NL80211_CMD_FRAME_TX_STATUS.
> How did you print that string? The other one, 59, is NL80211_CMD_FRAME,
> not NL80211_CMD_SET_TX_BITRATE_MASK.
> 
> It seems to me that you've messed up the nl80211.h header in either
> hostapd or the kernel.

Sorry, my bad. I've created small helper function and messed the enum -> txt
conversion macro in Vim which simply didn't handled the following assign case:

	NL80211_CMD_NEW_BEACON = NL80211_CMD_START_AP

I've compared the headers in the hostapd/kernel and here's the diff:

	--- nl_hostapd.h	2012-11-25 20:35:47.733001929 +0100
	+++ nl_linux.h	2012-11-25 20:36:04.997001488 +0100
	@@ -138,6 +138,11 @@
	 
		NL80211_CMD_CH_SWITCH_NOTIFY,
	 
	+	NL80211_CMD_START_P2P_DEVICE,
	+	NL80211_CMD_STOP_P2P_DEVICE,
	+
	+	NL80211_CMD_CONN_FAILED,
	+
		/* add new commands above here */
	 
		/* used to define NL80211_CMD_MAX below */

So I hope it should be ok. Thanks.

-- ynezz

	--- driver_nl80211.c.orig	2012-11-25 17:19:40.609302795 +0100
	+++ driver_nl80211.c
	2012-11-25 16:58:03.929335949 +0100
	@@ -1444,6 +1444,107 @@
		wpa_supplicant_event(drv->ctx, type, &event);
	 }
	 
	+static const char* cmd_txt(int cmd)
	+{
	+	const char *tmp[] = {
	+		"NL80211_CMD_UNSPEC",

			...snipped...

	+		"NL80211_CMD_CH_SWITCH_NOTIFY",
	+	};
	+
	+	return tmp[cmd];
	+}
	 
	 static void mlme_event(struct wpa_driver_nl80211_data *drv,
			       enum nl80211_commands cmd, struct nlattr *frame,
	@@ -1462,8 +1563,8 @@
			return;
		}
	 
	-	wpa_printf(MSG_DEBUG, "nl80211: MLME event %d", cmd);
	+	wpa_printf(MSG_DEBUG, "nl80211: MLME event %d (%s)", cmd, cmd_txt(cmd));
	 
		switch (cmd) {

