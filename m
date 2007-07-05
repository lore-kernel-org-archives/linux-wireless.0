Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:16536 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbXGEAXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 20:23:24 -0400
Received: by wa-out-1112.google.com with SMTP id v27so3418142wah
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2007 17:23:24 -0700 (PDT)
Message-ID: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
Date: Wed, 4 Jul 2007 20:23:24 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Multiple interfaces in mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added some debugging code to __ieee80211_rx() and I noticed in this loop:
		list_for_each_entry(sdata, &local->sub_if_list, list) {

that my adapter has two interfaces, not one like I expected. I have
the adapter in monitor mode. In the loop the first interface is
IEEE80211_IF_TYPE_AP and the second is IEEE80211_IF_TYPE_MNTR.
iwconfig only shows the monitor mode interface like I expected.

-- 
Jon Smirl
jonsmirl@gmail.com
