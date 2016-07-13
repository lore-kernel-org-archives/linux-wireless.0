Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36416 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbcGMUUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 16:20:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id x83so7062116wma.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 13:20:09 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 0/4 v1] Refactoring ieee80211_iface_work
Date: Wed, 13 Jul 2016 23:19:52 +0300
Message-Id: <1468441196-23503-1-git-send-email-br.shurik@gmail.com> (sfid-20160713_222019_250407_2DAE1C6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
This is my first patch(s).

I've decided to refactor ieee80211_iface_work function and break it down
to smaller better defined function.

I think these changes make the code much more readable and do not impose
no overhead.

I've tested these patches with sparse and checkpatch.pl 

Function names might not be descriptive enough.
Hope you find this useful.

Alex Briskin (4):
  0) [28e464b19aaaba90c8946fb979b58709d55dffcf] 
	Added new function ieee80211_is_skb_handled_by_pkt_type and moved
	some code from ieee80211_iface_work to reduce complexity and 
	improve readability

  1) [486e3d5abb4dc6361cdd923254a2b68d43dcdaba]
	Refactored code in ieee80211_is_skb_handled_by_pkt_type.
	"if () {} else if ()" replaced by switch case. 

  2) [9ef2eab8e831420bc6748a4466ffa6b7a99bf447]
	Added new function ieee80211_is_handled_by_frame_control and moved
	some code from ieee80211_iface_work to it.

  3) [1de8cdf9a0c05c6a21d9e43e5b55862f6efcf450] 
	Added new function ieee80211_handle_by_vif_type with code from
	ieee80211_iface_work.

	At this point ieee80211_iface_work seems to me much more readable
	and better understood. 

 net/mac80211/iface.c | 264 +++++++++++++++++++++++++++++----------------------
 1 file changed, 150 insertions(+), 114 deletions(-)

-- 
2.5.0

