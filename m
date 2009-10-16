Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:61234 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZJPMFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:05:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: cfg80211 / libertas: an unusual race
Date: Fri, 16 Oct 2009 14:03:37 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <200910131055.31739.hs4233@mail.mn-solutions.de> <1255687030.4095.327.camel@johannes.local>
In-Reply-To: <1255687030.4095.327.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910161403.37660.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't see this happening that way -- how are you even getting 
to
> __cfg80211_disconnected() if not through _send_deauth()?

See step 7a in the second table.  We got there via 
_send_deauth().

But later, step 3b in the second table (I kept the original 
numbers, so 3b happens after 7a time-wise!) we got into 
WARN_ON().

-- 
http://www.holgerschurig.de
