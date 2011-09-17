Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53852 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1IQXAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 19:00:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1R53ri-0007O8-9b
	for linux-wireless@vger.kernel.org; Sun, 18 Sep 2011 01:00:06 +0200
Received: from dslb-088-068-208-212.pools.arcor-ip.net ([88.68.208.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:00:06 +0200
Received: from an.alexsimon by dslb-088-068-208-212.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:00:06 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <an.alexsimon@googlemail.com>
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
Date: Sat, 17 Sep 2011 22:54:30 +0000 (UTC)
Message-ID: <loom.20110918T004437-426@post.gmane.org> (sfid-20110918_010021_257649_C3C63FC1)
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <c06e69fca577a9f162c3d69b4a7e7a212788ee7b.1316297595.git.an.alexsimon@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I came to the conclusion that the old patch was way too complicated and
confusing. Too much cases have to be taken into account when trying to
homogenize the HT mode.
I changed the code now that only mode given by iw is considered.

This yields in a way smaller patch and less refactoring as we don't need to
manipulate the beacon skb and match additionally for HT mode in scan results.

I think it's better that way.

Sorry for the confusion and/or extra work!

