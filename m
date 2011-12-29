Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:26358 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1L3HIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 02:08:11 -0500
Received: from cdptpa-omtalb.mail.rr.com ([10.127.143.53])
          by cdptpa-qmta02.mail.rr.com with ESMTP
          id <20111229224755167.LRSH14300@cdptpa-qmta02.mail.rr.com>
          for <linux-wireless@vger.kernel.org>;
          Thu, 29 Dec 2011 22:47:55 +0000
Received: from localhost (basement.kutulu.org [127.0.0.1])
	by basement.kutulu.org (Postfix) with ESMTP id 0C81B112002
	for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 17:46:48 -0500 (EST)
Received: from basement.kutulu.org ([127.0.0.1])
	by localhost (basement.kutulu.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qrd1Hm3yPIRo for <linux-wireless@vger.kernel.org>;
	Thu, 29 Dec 2011 17:46:47 -0500 (EST)
Received: from PORPOISE (PORPOISE.kutulu.org [192.168.69.91])
	by basement.kutulu.org (Postfix) with ESMTPSA id 440F1112001
	for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 17:46:47 -0500 (EST)
From: "Mike Edenfield" <kutulu@kutulu.org>
To: <linux-wireless@vger.kernel.org>
Subject: iwl3945: disassociating from current AP on rescan with kernels > 3.0
Date: Thu, 29 Dec 2011 17:46:48 -0500
Message-ID: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org> (sfid-20111230_080831_085763_B5CAD3F2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After upgrading to a v3.0 kernel, my Intel wireless adapter stopped working
when used with any UI-based wpa_supplicant front-end that does periodic
scans, such as NetworkManager and wicd. Whenever the software asks for an AP
scan, the device disconnects from its current AP and blacklists it, making
it impossible to reconnect until I kill wpa_supplicant. If I manually
configure wpa_supplicant and launch it directly, the adapter stays
associated with the AP properly.

I was able to reproduct this behavior with kernel version 3.0.4, 3.1.4, and
3.1.5, but downgrading to 2.6.39 or lower solves the problem. I haven't seen
any other reports of this problem specific to 3.x -- did I miss some other
step I need to do when upgrading?

