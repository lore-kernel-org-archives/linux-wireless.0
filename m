Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49977 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZIUHMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 03:12:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Mon, 21 Sep 2009 09:11:17 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909181849.22302.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909210911.17953.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, I think I need some more check:

NL80211_CMD_SCAN_TRIGGER is a root-only operation
NL80211_CMD_GET_SCAN is an any-user operation.

I think that a non-root user shouldn't be allowed to specify 
NL80211_ATTR_SCAN_EXPIRE that is smaller than 
IEEE80211_SCAN_RESULT_EXPIRE, right?

-- 
http://www.holgerschurig.de
