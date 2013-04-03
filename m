Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760468Ab3DCIzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:55:37 -0400
Message-ID: <1364979327.8351.7.camel@jlt4.sipsolutions.net> (sfid-20130403_105547_822977_DF066ACD)
Subject: Re: [PATCH for-3.9] brcmsmac: request firmware in .start() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 Apr 2013 10:55:27 +0200
In-Reply-To: <1364978488-5295-1-git-send-email-arend@broadcom.com> (sfid-20130403_104155_072423_E8AF0F80)
References: <1364978488-5295-1-git-send-email-arend@broadcom.com>
	 (sfid-20130403_104155_072423_E8AF0F80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 10:41 +0200, Arend van Spriel wrote:
> The firmware is requested from user-space. To assure the request
> can be handled it is recommended to do the request upon IFF_UP.
> For a mac80211 driver the .start() callback can be considered
> the equivalent.

FWIW, many drivers now don't do it on IFF_UP/start any more but do
request_firmware_nowait() in probe and only finish probing and
registering with mac80211 when they have the firmware file. This is
necessary if you have any device/driver capabilities that depend on the
firmware that need to be known before registering with mac80211.

johannes

