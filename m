Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:33441 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbYLOJIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 04:08:11 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1065054ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 01:08:10 -0800 (PST)
Message-ID: <dac45060812150108j2220722fwb344095734b3e9ee@mail.gmail.com> (sfid-20081215_100828_775010_89DF7154)
Date: Mon, 15 Dec 2008 11:08:09 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: power saving in mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have two short questions about power saving in mac80211:

1) Is there support in the linux kernel for power saving when in AdHoc mode ?

According to the docs, announcement messages called ATIM
(announcement traffic indication messages) should be sent.
Yet, grepping under net/wireless/mac for atim does not find anything
(except one comment line in mlme.c).

2) As I find out from the docs, there should be no buffering for ordered frames.
When we handle multicast frames, there is a check for oredring;
In ieee80211_tx_h_multicast_ps_buf() there is a call to ieee80211_has_order()
and we do not buffer the packet when there is ordering.
On the other hand , when we handle unicast packets, there is no check
for ordering (see: ieee80211_tx_h_unicast_ps_buf()).

My question is: shouldn't we check ordering also for unicast packets?

Regards,
Mark
