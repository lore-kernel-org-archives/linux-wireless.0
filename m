Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35064 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbXL2WPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 17:15:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: rc80211_pid fails to remove debugfs files
Date: Sat, 29 Dec 2007 23:14:56 +0100
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
MIME-Version: 1.0
Message-Id: <200712292314.56620.mb@bu3sch.de> (sfid-20071229_221600_235896_2666134B)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rc80211_pid fails to remove the debugfs files properly.
In debugfs I see phyX directories for PHYs that are long gone.
The only content is the rc80211_pid directory with its files.

Last time I looked through the PID code I saw that it does not
do proper error checking for the creation of debugfs files.
But error checking is important, as it _will_ otherwise result
in unpredicted behaviour. Debugfs is pretty nasty. :)
For example if creation of the root directory failed, it will
put the files all into the debugfs root. And yes, this _does_
happen. We had similiar problems and bugreports from people
in b43.

So please add errorchecking.

-- 
Greetings Michael.
