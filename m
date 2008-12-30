Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43953 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYL3LhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 06:37:23 -0500
Date: Tue, 30 Dec 2008 13:37:14 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org,
	openwrt-devel@lists.openwrt.org
Subject: Re: mac80211 (ath9k, ath5k, etc.) set BSSID Patch
Message-ID: <20081230113714.GA31451@jm.kir.nu> (sfid-20081230_123729_392767_F92A95B9)
References: <20081230025651.6500@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081230025651.6500@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 03:56:51AM +0100, Alina Friedrichsen wrote:

> this patch corrects some bugs of the mac80211 wireless driver framework related to setting a static BSSID in the ad-hoc mode (e.g. for mesh networks like OLSR).

This is not how IEEE 802.11 IBSS is supposed to work. If there are
issues in IBSS splits, merges, or timesync, I would consider fixes to
those to be preferred over hacks that hide the issues and cause
interoperability issues with standard compliant IBSS implementations.

Anyway, since I don't really care that much about IBSS to actually start
using lots of time to fix problems there, I would not object to this
type of change as long it does not change the default behavior (i.e., by
default, mac80211 should operate in standard compliant manner) and the
users are not mislead to enable such a hack while still believing that
their devices are operating in a standard IBSS.

-- 
Jouni Malinen                                            PGP id EFC895FA
