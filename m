Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:63932 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZE3UrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 16:47:22 -0400
Received: by bwz22 with SMTP id 22so6762675bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 13:47:22 -0700 (PDT)
Subject: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks wireless
 on my system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Sat, 30 May 2009 23:47:17 +0300
Message-Id: <1243716437.26585.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I use nl80211 wpa_suppicant driver.
With this commit (have just bisected) I can't connect to same AP twice,
and usually only a module reload, or somtimes restart of supplicant
help.
Actually usually I can't connect again after first successful connection
at all.


With wext supplicant works, but still sometimes hangs in same way.

commit 1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue May 19 22:16:25 2009 +0200

    mac80211: don't try to do anything on unchanged genIE
    
    When the genIE hasn't changed there's no reason to kick
    the state machine since it won't be able to do anything
    new -- doing this decreases the useless work we do for
    reassociating because if we do kick the state machine
    it will try to find a usable BSS but there might not be
    one because wpa_supplicant will only change the BSSID
    a little later.
    
    In a sense this is a workaround for userspace behaviour,
    but on the other hand userspace cannot really keep track
    of what the kernel currently has for genIE since any
    process could have changed that while wpa_supplicant
    wasn't looking.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Best regards,
	Maxim Levitsky

