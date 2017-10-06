Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55452 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdJFNzf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 09:55:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1e0T6D-0001pW-UZ
        for linux-wireless@vger.kernel.org; Fri, 06 Oct 2017 15:55:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] cfg80211: in-kernel regulatory database
Date: Fri,  6 Oct 2017 15:55:28 +0200
Message-Id: <20171006135532.29550-1-johannes@sipsolutions.net> (sfid-20171006_155545_841080_0D0FFC26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a resend of the database-as-firmware patches.

I've changed it to kmemdup() instead of hanging on to the struct firmware,
that way reload actually works without piggy-backing on the existing one
that's already loaded.

I've also changed it so you can configure it to not trust the built-in keys
and also configure it to load keys from an external directory during build.

So I think literally the only thing that this still needs is Seth's key.

johannes
