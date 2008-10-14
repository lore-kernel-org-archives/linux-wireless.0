Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57751 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbYJNVJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:09:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] make ieee80211 invisible
Date: Tue, 14 Oct 2008 23:09:00 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1224006562.10113.47.camel@johannes.berg>
In-Reply-To: <1224006562.10113.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810142309.00479.mb@bu3sch.de> (sfid-20081014_230934_127892_4B5E43EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 October 2008 19:49:22 Johannes Berg wrote:
> 
> This makes CONFIG_IEEE80211 invisible. The drivers that require it
> (ipw2100, ipw2200, hostap) select it, and everybody else really
> shouldn't even think about using it. Also, since there really is
> no point in compiling anything without crypto support these days,
> remove the crypto options and just enable them, leaving only the
> debugging option which only shows up when a driver is select that
> requires it. This makes it hard to enable, but most people wouldn't
> want to anyway.

I think in the long term we should also rename it to ipw-ieee80211
and move it into another directory like drivers/net/wireless/ipw-ieee80211.
This way it's a lot less confusing for new developers joining the wireless developers.

(Probably also rename the symbols. I'm not sure if it's worth it, however)

-- 
Greetings Michael.
