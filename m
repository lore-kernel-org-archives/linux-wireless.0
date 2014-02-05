Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35203 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaBERpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 12:45:07 -0500
Received: by mail-oa0-f48.google.com with SMTP id l6so860602oag.7
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 09:45:05 -0800 (PST)
Message-ID: <52F278A0.3050605@lwfinger.net> (sfid-20140205_184512_006545_EE4F0772)
Date: Wed, 05 Feb 2014 11:45:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: PHY transmission errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.kernel.org/show_bug.cgi?id=70031, there is a report of a 
regression in 3.14-rc1 for a 14e4:4331 device. Kernel 3.13 is OK. Can anyone 
with a 4331 confirm that PHY transmission errors are a lot more prevalent with 
either mainline 3.14-rc1 or the current wireless-testing than with 3.13?

I do not have that particular device, but I do not see any changes for my 
14e4:4315; however, the 4331 has a different PHY than does the 4315.

A review of the commits between 3.13 and 3.14-rc1 shows nothing for bcma that 
should cause this effect. For b43, the only one that might cause this is commit 
64e5acb entitled "b43: fix the wrong assignment of status.freq in b43_rx()". 
That was clearly a bug and it fixed thing for my system, but we must consider if 
that bug was also masking some other problem that is now revealed.

I have asked the bug reporter at b.k.o if it is possible to bisect the problem.

Larry
