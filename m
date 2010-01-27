Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40318 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0A0Pjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 10:39:36 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 303235001C
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 16:39:35 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fY24eECBdk8s for <linux-wireless@vger.kernel.org>;
	Wed, 27 Jan 2010 16:39:35 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95F831C.dip0.t-ipconnect.de [217.95.131.28])
	by mx51.mymxserver.com (Postfix) with ESMTP id 8EFBB50017
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 16:39:33 +0100 (CET)
Received: from schurig.mn-solutions.de (schurig.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 9BCF41E0036
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 16:39:32 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: BUG: STATION_INFO_TX_BITRATE broken?
Date: Wed, 27 Jan 2010 16:39:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201001271639.10941.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have code in my driver that does

	sinfo->txrate.legacy = lbs_rates[i].bitrate * 10;
	sinfo->filled |= STATION_INFO_TX_BITRATE;


But later, "iw wlan0 link" gives me:

	# iw wlan0 link
        Connected to 00:13:19:80:da:30 (on wlan0)
        SSID: MNHS
        freq: 2462
        failed to parse nested attributes!

Both iw and linux-wl are from git HEAD.

-- 
http://www.holgerschurig.de
