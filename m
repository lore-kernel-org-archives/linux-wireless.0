Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:65167 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZGQTEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 15:04:51 -0400
Received: by bwz28 with SMTP id 28so915756bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 12:04:49 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/8] wl1251 sdio interface
References: <20090717184643.25883.95065.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 17 Jul 2009 22:04:47 +0300
In-Reply-To: <20090717184643.25883.95065.stgit@tikku> (Kalle Valo's message of "Fri\, 17 Jul 2009 21\:47\:39 +0300")
Message-ID: <87r5wfp1v4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Here is v2 of Bob's wl1251 sdio patches. I have now rebased them on
> top of wl1251/wl1271 split patches. Only compile-tested because I
> don't have working test setup right now (neither spi or sdio), but I
> should have access to one in two weeks.

I forgot to mention that wl1251 most probably is still broken regards to
bssid handling. I will fix this after my (current) vacation, unless
someone else is faster. To get wl1251 temporarily working, this patch
must be reverted:

    commit cc3ec8cb518534c1c593e5f2682710d33c903627
    Author: Johannes Berg <johannes@sipsolutions.net>
    Date:   Thu May 14 13:10:14 2009 +0200

    mac80211: fix managed mode BSSID handling
    
    Currently, we will ask the driver to configure right away
    when somebody changes the desired BSSID. That's totally
    strange because then we will configure the driver without
    even knowing whether the BSS exists. Change this to only
    configure the BSSID when associated, and configure a zero
    BSSID when not associated.

Oddly enough I can't find this patch anymore in wireless-testing, I
could only find a revert. I don't know what happened to it.

-- 
Kalle Valo
