Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37633 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2IKGLZ (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 11 Sep 2012 02:11:25 -0400
Received: by vbbff1 with SMTP id ff1so166966vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 23:11:16 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Sep 2012 14:11:16 +0800
Message-ID: <CALx5=V_CL_gF6CFTa5jMY8zU3RJ9hKRpYhtAQWc6e6ecZSkzrw@mail.gmail.com> (sfid-20120911_081128_242399_FE62B31D)
Subject: Disconnect with AP and not able to scan anymore.
From: Matt Chen <machen@suse.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,
I am running the v3.0 kernel and my Ralink wifi module is [1814 539a].
I found the mac80211 would do the ieee80211_sta_work() and then go to

           } else {
                        /*
                         * We actually lost the connection ... or did we?
                         * Let's make sure!
                         */
                        wiphy_debug(local->hw.wiphy,
                                    "%s: No probe response from AP %pM"
                                    " after %dms, disconnecting.\n",
                                    sdata->name,
                                    bssid, probe_wait_ms);

                        ieee80211_sta_connection_lost(sdata, bssid);
             }

So the mac80211 would do ieee80211_sta_connection_lost() and then the
connection between AP and station would be lost. At this time, I found
the wifi interface is not able to do any scan now, ie no any AP is
showed after do "iwlist wlan0 scan".
Once I "ifconfig wlan0 down" and "ifconfig wlan0 up", everything is
working again.

Is there way or tool suggested to observe or debug the connection
status between station and AP ? I think it would be something working
wrong in rt2x00 driver.

-- 
Thank you.
