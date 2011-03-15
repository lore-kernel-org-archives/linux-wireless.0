Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab1COMFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 08:05:08 -0400
Subject: RE: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
	 <1299874885.4320.5.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA4C2D82@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 13:04:58 +0100
Message-ID: <1300190698.5596.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have a question regarding the 11n 20MHz/40MHz channel width
> configuration:
> 
> Since the 802.11n Draft 2.0 System Interoperability Test Plan v1.1
> requires the default configuration being set to 20MHz, is there any
> way to set the channel width to 40MHz at run-time?

In mac80211 have a module parameter "ieee80211_disable_40mhz_24ghz"
which, for backward compatibility reasons, actually defaults to false,
so you need to set it to true to get a compliant system. When a system
is integrated, this parameter can be set as default.

I don't think it really is necessary to set this at runtime.

I guess I see two options:
 1) move the module parameter to cfg80211, and check the sdata HT config
    in the driver again when this is needed
 2) have your own module parameter like it

The first would be slightly more generic, but an OEM integrating a
device into their system and doing WFA testing will do device-specific
things anyway ...

johannes


