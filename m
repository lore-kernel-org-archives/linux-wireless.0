Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYFMHfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:35:46 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080612135936.GA5031@tuxdriver.com>
References: <484FEA26.1040305@gmail.com>
	 <1213241315.7814.696.camel@debian.sh.intel.com>
	 <20080612135936.GA5031@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 15:35:23 +0800
Message-Id: <1213342523.7814.865.camel@debian.sh.intel.com> (sfid-20080613_093557_086262_4624B7EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
> How does the hardware scan differ from what mac80211 does when
> scanning?

Software scan disables Tx during the scan process while hardware scan
doesn't. So you are expected to see continous ping responds instead of a
freeze during the scan period. Hardware scan is also more efficient
since it is handled by the firmware.

> I still see a lot of mysterious iwlwifi (especially iwl3945)
> problems in Fedora that seem to disappear with disable_hw_scan=1.

I don't see this problem from my side. I'll do more testing for 3945.

> Honestly I'm tempted to change it to "enable_hw_scan" instead...

Give the advantages, I'd like to use it if we can fix the bug (I haven't
seen what the bug is myself). But you are free to change the default
value until it is fixed. There is no such problem for 4965, right?

Thanks,
-yi

