Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYBYG3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 01:29:23 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203688708.7082.22.camel@johannes.berg>
References: <1203520709.17534.68.camel@johannes.berg>
	 <1203574345.3099.64.camel@debian.sh.intel.com>
	 <1203591498.17534.179.camel@johannes.berg>
	 <1203651948.3082.93.camel@debian.sh.intel.com>
	 <1203688708.7082.22.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 14:30:25 +0800
Message-Id: <1203921025.3090.9.camel@debian.sh.intel.com> (sfid-20080225_062940_238410_3F5C9509)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2008-02-22 at 14:58 +0100, Johannes Berg wrote:
> I thought you just said the firmware follows the powersave transitions
> by itself (by looking at the frames)? In my hypothetical scheme the
> driver/stack notifies the firmware about them.

Alright, the iwlwifi firmware works partially by itself on powersave. It
switches from wake to sleep by looking at the frames and from sleep to
wake by driver/stack notification.

BTW, I've put our iwl4965 AP code at below address. We tested it on
2.6.22 kernel. The code is not very up to date but you can at least get
a working AP with an iwl4965 card.
http://www.kernel.org/pub/linux/kernel/people/chuyee/wireless/iwl4965_ap/

To install mac80211:

$ cd mac80211
$ make patch_kernel
$ recompile your kernel and modules && install

To compile and run the hostapd:

$ cd hostapd
$ make KSRC=/lib/modules/`uname -r`/build
$ ./hostapd hostapd.conf

Thanks,
-yi

