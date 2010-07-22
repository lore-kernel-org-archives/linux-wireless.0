Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0GVMec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 08:34:32 -0400
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100721184040.GA22968@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 14:34:15 +0200
Message-ID: <1279802055.12439.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> [82970.511341] ------------[ cut here ]------------
> [82970.511365] WARNING: at net/mac80211/scan.c:262 ieee80211_scan_completed+0x137/0x1d0()

You don't happen to have a way of reproducing this? I have been
suspecting races in this area, and came up with this patch to fix them,
but haven't really validated it yet:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-hw-scan-locking.patch

johannes

