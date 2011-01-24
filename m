Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1AXLkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:40:31 -0500
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:41:23 +0100
Message-ID: <1295869283.3639.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
> Support passing SSID and probe-response template to drivers.
> This data can be used to offload the beacon -> probe-req -> probe-resp
> process to HW.

I still think you should add a wiphy flag and advertise it in nl80211 to
advertise and request this behaviour. That will allow hostapd (and
mac80211 in IBSS mode) to not reply to probe requests when they aren't
filtered out by the device, and will allow hostapd/wpa_s to also
restrict its operation to non-P2P etc. as Jouni pointed out. For P2P
then that will have to be extended more I guess, and the firmware
functionality be improved -- or even disabled.

johannes

