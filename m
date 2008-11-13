Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53345 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYKMPjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 10:39:09 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 0/3] rtl8187: throughput fix/conf_tx callback/ack tx pkts
Date: Thu, 13 Nov 2008 10:39:13 -0500
Message-Id: <1226590756-10743-1-git-send-email-herton@mandriva.com.br> (sfid-20081113_163916_373661_A19D49F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three patches that fixes/introduces the following in rtl8187:
- Fixes 8187B reported throughput issues after short slot handling addition.
- Implement conf_tx callback, instead of hardcoding some tx queue values.
- Make rate control work for 8187B sending correct feedback about transmitted
  packet status, using one of the Bulk In endpoints that provides this info.
