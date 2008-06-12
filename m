Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbYFLHJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 03:09:27 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Zhu Yi <yi.zhu@intel.com>
To: drago01 <drago01@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <f6ca9fed0806112342u1695182brfb99d53de67a77a2@mail.gmail.com>
References: <484FF375.8010002@gmail.com>
	 <1213237561.7814.688.camel@debian.sh.intel.com>
	 <f6ca9fed0806112342u1695182brfb99d53de67a77a2@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 15:08:44 +0800
Message-Id: <1213254524.7814.717.camel@debian.sh.intel.com> (sfid-20080612_090930_110778_4506141D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 08:42 +0200, drago01 wrote:
> > The card will receive an interrupt when you disable the rf kill
> switch
> > anyway [...]
> It does? I thought thats only true for 4965 ... 3945 uses an ucode
> event for that thats why it does not detect the rfkill state when the
> interface is down.

I was wrong. The card won't receive interrupt if the interface is down
since we have disable the device. So the driver does nothing when you
disable the rf_kill switch when the interface is down. But if you do so
and then issue an `ifconfig wlan0 up`, the iwl3945_up() will read the
hardware rf_kill register CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW before
load the ucode and initialize everything. This is both true for 3945 and
4965.

Thanks,
-yi

