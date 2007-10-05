Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galaxy.systems.pipex.net ([62.241.162.31]:43117 "EHLO
	galaxy.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbXJEWTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 18:19:14 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Mode selection in mac80211
Date: Fri, 5 Oct 2007 23:19:10 +0100
Cc: rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710052319.10600.linux@baker-net.org.uk> (sfid-20071005_231916_055041_CD49F30E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've observed an undesirable change in behaviour of rt2x00 as a result of 
Johannes Berg's patch 3d4803379613c763f5a7863e8249b63d190af5e6
(remove all prism2 ioctls).

It used to consistently default to 802.11g mode on g capable hardware. Because 
that patch removed the lines

-                               /* Use next_mode as the mode preference to
-                                * resolve non-unique channel numbers. */
-                               if (set && mode->mode != local->next_mode)
-                                       continue;

in ieee80211_set_channel it now defaults to 11b unless I change the code that 
calls ieee80211_register_hwmode. (I realise that the next_mode test is no 
longer "right").

This is because ieee80211_set_channel will now prefer to select whichever was 
the last mode for which the driver called ieee80211_register_hwmode whereas 
the previous behaviour preferred the first registered mode. It seems as 
though if there was a way to avoid calling Iieee80211_set_channel then the 
setting of oper_hw_mode in ieee80211_register_hwmode would still prefer the 
first registered mode.

Is it intended that the order of calling ieee80211_register_hwmode should 
determine which mode should be preferred when multiple modes exist on the 
same channel or is there either already or planned a better option for driver 
writers? If calling order should determine preference should it be first or 
last registered?

Adam Baker
