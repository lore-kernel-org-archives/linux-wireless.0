Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYEPP74 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:59:56 -0400
Subject: mrv8k vs. mac80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 12:00:21 -0400
Message-Id: <1210694421.24737.19.camel@localhost.localdomain> (sfid-20080516_175959_106487_A186F4A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

mrv8k has commands that should be sent before a scan is started, and
after a scan has finished.  There aren't really pre/post scan hooks in
mac80211, though there certainly could be without too much trouble.  The
other possibility is to inspect the filter flags when
ops->configure_filter gets called, since FIF_BCN_PRBRESP_PROMISC gets
flipped before and after the scan.  But that seems ugly and unstable.

Any objections to adding ops->pre_scan and ops->post_scan hooks?  Or
should I just use the configure_filter hack...  or is there a better
way?

Dan

