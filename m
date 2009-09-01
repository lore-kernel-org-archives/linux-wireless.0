Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48039 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169AbZIAV0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 17:26:01 -0400
Received: from outgoing.mit.edu (OUTGOING-AUTH.MIT.EDU [18.7.22.103])
	by biscayne-one-station.mit.edu (8.13.6/8.9.2) with ESMTP id n81LQ1Gi019565
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2009 17:26:01 -0400 (EDT)
Received: from ctpornette.lns.mit.edu (ctpornette.lns.mit.edu [198.125.162.195])
	(authenticated bits=0)
        (User authenticated as luto@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.13.6/8.12.4) with ESMTP id n81LQ08j008396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2009 17:26:01 -0400 (EDT)
Message-ID: <4A9D9168.2070608@mit.edu>
Date: Tue, 01 Sep 2009 17:26:00 -0400
From: Andy Lutomirski <luto@MIT.EDU>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 2.6.31 regression: iwlagn power_level no longer works
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2.6.30.5, I can echo 1 >/sys/class/net/wlan0/device/power_level, and 
the value changes to 1, my wakeup rate goes way down, and my power 
consumption (as measured by powertop) drops noticeably.

On 2.6.31-rc7, I can still echo 1 to that file, but nothing happens, and 
the value I get if I 'cat power_level' remains at 0.

My kernel configs are as identical as 'make oldconfig' knows how to make 
them.

Any ideas?
