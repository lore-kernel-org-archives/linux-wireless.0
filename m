Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1AKIZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:25:29 -0500
Subject: Re: [PATCH] wl12xx: reset 5ghz num channels on hw init
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1294693444-30807-1-git-send-email-arik@wizery.com>
References: <1294693444-30807-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 09:25:27 +0100
Message-ID: <1294734327.3611.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-10 at 23:04 +0200, Arik Nemtsov wrote:
> The number of 5ghz channels is set to 0 when 11a is not supported in the
> NVS file. When a single rmmod/insmod of wl12xx_sdio this leads to a
> supported band (5ghz) with 0 supported channels, which mac80211
> considers illegal.

The setting to 0 shouldn't be happening in a global structure anyway
since that way you can't support two different devices in the same
system!!

johannes

