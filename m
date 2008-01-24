Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60249 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYAXKuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 05:50:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: mac80211 does seem to have a netdev refcount bug
Date: Thu, 24 Jan 2008 11:48:25 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200801241148.25456.mb@bu3sch.de> (sfid-20080124_105006_255479_E3E01AF7)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seems to be a netdevice refcounting (freeing) bug in mac80211.
I frequently see the "waiting for netdev to become free, refcount = 1"
message on rmmod. I don't remember the message text exactly, but I think you
know what I mean.

Is there any way I can debug this and find out who is leaking the resource?

-- 
Greetings Michael.
