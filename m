Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945961Ab2LFQr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tgebc-0001Oe-WE
	for linux-wireless@vger.kernel.org; Thu, 06 Dec 2012 17:47:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/24] regulatory fixes, cleanups & improvements
Date: Thu,  6 Dec 2012 17:47:24 +0100
Message-Id: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174756_392946_04B4B998)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The biggest improvement is using RCU, this will allow checking
against the regdomain from any context and makes the wiphy's
regd pointer safe to use for drivers. It also simplifies the
locking since cfg80211_mutex isn't needed any more for those
things, only for wdev iteration/access. 

Over my previous [RFC] series, the changes are:
 old 18: dropped, will be part of VHT changes
 new 01: fixing an array access bug
 new 02: clean up the intersect more, in particular
         don't memset all the time
 new 20: fix a memory leak
 new 21: don't let cfg80211_regdomain pointer be NULL
 new 22/23: RCU
 new 24: use IS_ERR macro family

johannes

