Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33107 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279AbbLPRc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 12:32:28 -0500
Received: by mail-qk0-f182.google.com with SMTP id k189so75407788qkc.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 09:32:28 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id 35sm2973093qkv.23.2015.12.16.09.32.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Dec 2015 09:32:27 -0800 (PST)
Received: from bob by hash with local (Exim 4.84)
	(envelope-from <me@bobcopeland.com>)
	id 1a9Fw7-0004Rw-RR
	for linux-wireless@vger.kernel.org; Wed, 16 Dec 2015 12:32:23 -0500
Date: Wed, 16 Dec 2015 12:32:23 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Subject: [ANNOUNCE] New location for wireless-testing tree
Message-ID: <20151216173223.GF4073@localhost> (sfid-20151216_183231_038204_D69A4DE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported previously[1], John Linville will be moving on from maintenance
of the wireless-testing[2] tree at the end of the year.  A huge thank you to
John for doing all this work for so many years!

We now have a shared wireless directory on kernel.org where we (currently
myself and Kalle as backup) will continue to maintain this tree going
forward.  The new tree can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git

Note: unlike John's tree, we are going to try rebasing this tree on every
build (like linux-next) instead of merging the downstream trees, in order
to avoid certain merge problems when those trees are rebased.

This means that if you are working directly off of wireless-testing, use
'git pull --rebase' to sync, instead of just 'git pull'.

We'll see how this goes and reassess after a couple of cycles.

Please let me know of any issues.

[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/145291

[2] wireless-testing is an integration testing tree, consisting of:

 * Linus's latest -rc
 * patches in mac80211 and wireless-drivers (for the upcoming release)
 * patches in mac80211-next and wireless-drivers-next (for the next release)

It is not pulled into any upstream tree, but it should be a pretty good
indication of what is baking in Linux wireless for the next release, without
having unrelated changes from all the other subsystems as in linux-next.

-- 
Bob Copeland %% http://bobcopeland.com/
