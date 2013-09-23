Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:38573
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab3IWUAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 16:00:09 -0400
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.7/8.14.7) with ESMTP id r8NK08cY007482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 16:00:08 -0400
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.7/8.14.7/Submit) id r8NK08XO007481
	for linux-wireless@vger.kernel.org; Mon, 23 Sep 2013 16:00:08 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.12 0/2] Fix cw1200_spi interrupt delivery
Date: Mon, 23 Sep 2013 16:00:02 -0400
Message-Id: <1379966404-7047-1-git-send-email-pizza@shaftnet.org> (sfid-20130923_220015_537873_A84A2944)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The earlier fix for cw1200_spi driver's interrupt handling woes solved 
the oops, but it had the side effect of making interrupt delivery 
unreliable nearly to the point of uselessness.

Rather than try to fix the fix, just revert entirely and convert it to 
using Linux's threaded oneshot irq handling.  Far simpler, and it 
actually seems to work.

