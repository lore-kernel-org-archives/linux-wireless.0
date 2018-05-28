Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45326 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937731AbeE1Nrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:47:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1fNIUy-0000GZ-Lo
        for linux-wireless@vger.kernel.org; Mon, 28 May 2018 15:47:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] improved scan privacy
Date: Mon, 28 May 2018 15:47:36 +0200
Message-Id: <20180528134741.10386-1-johannes@sipsolutions.net> (sfid-20180528_154819_436156_4C5CD792)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the random MAC address, we all expected the next level of
escalation in the "tracking war". This comes in form of the APs
being able to track clients using their sequence numbers and to
some extent HT/VHT information which tends to be pretty unique,
as evidenced by the fingerprinting the Google Fiber folks did.

Extend scan privacy by adding two new flags:
 * random SN
   this randomizes the sequence number of the probe request frames transmitted
 * minimal content
   reduces the probe request content to just the SSID, supported rates, DS
   element and - if given - requested elements from userspace

johannes
