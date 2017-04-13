Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55452 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbdDMNz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:55:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1cyfE3-0008Mw-Ay
        for linux-wireless@vger.kernel.org; Thu, 13 Apr 2017 15:55:55 +0200
Message-ID: <1492091754.29526.3.camel@sipsolutions.net> (sfid-20170413_155559_755491_749C0C47)
Subject: Re: [RFC v2 3/3] mac80211: support bpf monitor filter
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 13 Apr 2017 15:55:54 +0200
In-Reply-To: <20170413135155.27265-3-johannes@sipsolutions.net> (sfid-20170413_155230_224654_63AD579D)
References: <20170413135155.27265-1-johannes@sipsolutions.net>
         <20170413135155.27265-3-johannes@sipsolutions.net>
         (sfid-20170413_155230_224654_63AD579D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If anyone wants to play with this ...

The necessary code is in the "bpf" branch of my mac80211-next and iw
trees. The setup of the filter is a bit stupid right now - the test
program in mac80211-next/bpf (samples/bpf/wifimon) will call iw for the
nl80211 part ... I should make an ELF parser in iw, but that's not as
simple as using the bpf loader in samples/bpf/ :)

johannes
