Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:17226 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761393AbXJDVlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 17:41:07 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, Daniel Drake <dsd@gentoo.org>,
	johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix TX after monitor interface is converted to managed
References: <20071004113343.552139D502B@zog.reactivated.net>
	<200710041706.06182.mb@bu3sch.de>
	<20071004151956.GE6037@tuxdriver.com>
	<200710041311.37997.flamingice@sourmilk.net>
	<20071004181516.GH6037@tuxdriver.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 04 Oct 2007 14:31:26 -0700
In-Reply-To: <20071004181516.GH6037@tuxdriver.com> (John W. Linville's message of "Thu, 4 Oct 2007 14:15:16 -0400")
Message-ID: <ada4ph6bm8h.fsf@cisco.com> (sfid-20071004_224126_755037_1B2CEE99)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > Programming with assertions (and BUG_ON is a form of that) is
 > generally a good practice.  Almost any book or other source on
 > good programming practices will agree.  Yes, it can be overdone.
 > But I don't really think that is the case here, since the check is
 > relatively inexpensive and the consequence should it ever *somehow*
 > happen could be a something wierd (crash, corruption, etc) w/o any
 > other indication of what occured.

The problem with BUG_ON is that it kills the whole system.  So every
time you add a BUG_ON into code, you have to weigh whether the problem
you detected is so severe that the right response is to panic.  For
example, I can see panicking on something fundamental like corrupted
page tables.  However I would submit that the wireless stack should
*never* use BUG_ON -- printing a warning and trying to limp on seems
preferable to me.

 - R.
