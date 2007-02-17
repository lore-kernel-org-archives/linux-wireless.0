Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:57682 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946340AbXBQAuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 19:50:16 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIDkz-0005x3-5W
	for linux-wireless@vger.kernel.org; Fri, 16 Feb 2007 19:48:53 -0500
Subject: Re: wireless-dev.git breaks wireless extensions
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1171670990.3575.50.camel@johannes.berg>
References: <1171670057.28539.5.camel@dv>
	 <1171670990.3575.50.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 19:50:14 -0500
Message-Id: <1171673414.28874.4.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-02-17 at 01:09 +0100, Johannes Berg wrote:
> On Fri, 2007-02-16 at 18:54 -0500, Pavel Roskin wrote:
> > Hello!
> > 
> > Today's wireless-dev.git breaks wireless extensions.  It forces
> > CONFIG_CFG80211 to be enabled.
>                         ^^^^^^^ ??????

>From net/d80211/Kconfig:

config D80211
        tristate "Generic IEEE 802.11 Networking Stack (dscape)"
        select CRYPTO
        select CRYPTO_ECB
        select CRYPTO_ARC4
        select CRYPTO_AES
        select CRC32
        select WIRELESS_EXT
        select CFG80211

It means if I want D80211, CFG80211 will be selected for me.  Last time
I pulled the sources (a few days ago) I was able to disable CFG80211.

Even if I compile D80211 and CFG80211 as modules and load MadWifi, lsmod
shows that cfg80211 is not loaded, but the iwconfig output is still
wrong.  Some part of cfg80211 must be compiled into the kernel.

-- 
Regards,
Pavel Roskin

