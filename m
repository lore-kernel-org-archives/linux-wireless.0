Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:54135 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbYGAUWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 16:22:13 -0400
Message-ID: <486A9248.9000607@lwfinger.net> (sfid-20080701_222217_639579_E653A96D)
Date: Tue, 01 Jul 2008 15:23:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Harvey Harrison <harvey.harrison@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Commit c4438fa71bf412862ed0b73111956b0ffd8209d3 breaks WPA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the latest wireless-testing update, b43 was unable to connect to 
my WPA network. Bisection leads to the following commit as the culprit:

commit c4438fa71bf412862ed0b73111956b0ffd8209d3
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Thu Jun 26 13:21:50 2008 -0700

     mac80211: remove ieee80211_get_hdr_info

     Move the address selection into the michale_mic header 
calculation helper
     and pass a pointer to the ieee80211_hdr directly.

     Reorganize ccmp_special_blocks while eliminating the unneeded 
sa/da/qos
     variables.

     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 c77af99ab0477f3ec3159af8566fb1de61856ab8 
7fa906d1d2acc6f9d88b923eed0990b9b14ea830 M      net

This commit was confirmed as the problem by reverting it.

Larry
