Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:39378 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZHND1o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 23:27:44 -0400
Received: from [76.91.220.157] (helo=[192.168.1.20])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1Mbn4L-0004bZ-MN
	for linux-wireless@vger.kernel.org; Thu, 13 Aug 2009 20:03:05 -0700
Message-ID: <4A84D3E4.5050406@symas.com>
Date: Thu, 13 Aug 2009 20:03:00 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: compat-wireless-2009-08-13 ath9k timeouts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just built this on my 2.6.31-rc5 kernel. Using the driver results in a flood of

[   78.598403] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.599508] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.600500] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.600833] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.600833] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.600833] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
[   78.601378] ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT

in dmesg, and throughput is extremely slow. Surprising that there are multiple 
messages in a single time tick.

I also tried with the ath9k driver from wireless-testing, as of commit 
3fbf09eb3916 and got the same result.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
