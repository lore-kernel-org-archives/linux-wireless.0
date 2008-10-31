Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:40355 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJaPlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 11:41:49 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly ack tx pkts
Date: Fri, 31 Oct 2008 11:42:00 -0400
Message-Id: <1225467722-31684-1-git-send-email-herton@mandriva.com.br> (sfid-20081031_164154_693146_E9307DA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two patches for two current issues in rtl8187:
- First it should implement conf_tx callback, instead of hardcoding some tx
  queue values.
- The second one should make rate control work for 8187B sending correct
  feedback about transmitted packet status, using one of the Bulk In endpoints
  that provides this info. Unfortunately after recently rate control api rewrite
  in my testing here I don't get anymore greater than 1M rate with pid, before I
  would still get until 9M (and after some time falling to 1M, then going back
  up in steps, and so on) on same environment, don't know if it's expected to
  the new rate control api be more strict/have different behaviour, or if
  something additional must be done in rtl8187 (the link/signal quality may be
  too low and may be new rate control changes are more sensitive).

Please test and check if there are any additional issues.
