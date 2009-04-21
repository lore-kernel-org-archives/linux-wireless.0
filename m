Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:34139 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDUFgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 01:36:54 -0400
Received: by bwz7 with SMTP id 7so1570509bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 22:36:52 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: p54: power save disable patch twice
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 21 Apr 2009 08:36:50 +0300
Message-ID: <87hc0iftzh.fsf@litku.valot.fi> (sfid-20090421_073658_496873_F73536A8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I noticed that latest wireless-testing had this patch twice:

    p54: deactivate broken powersave function
    
    This patch deactivates powersave in station mode.
    
    It does not work correctly yet, so the code does more harm than
    good.
    
    Reported-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Christian Lamparter <chunkeey@web.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

The first patch removes IEEE80211_HW_SUPPORTS_PS and
IEEE80211_HW_PS_NULLFUNC_STACK, and the second patch removes only
IEEE80211_HW_BEACON_FILTER. I assume that the idea was to remove
everything in one go.

-- 
Kalle Valo
