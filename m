Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51994 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751864AbdFMIUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 04:20:08 -0400
Message-ID: <1497342000.6068.3.camel@sipsolutions.net> (sfid-20170613_102047_851783_2C64239D)
Subject: Re: [PATCH 6/6] mac80211/wpa: use constant time memory comparison
 for MACs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 13 Jun 2017 10:20:00 +0200
In-Reply-To: <20170610025912.6499-7-Jason@zx2c4.com>
References: <20170610025912.6499-1-Jason@zx2c4.com>
         <20170610025912.6499-7-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-06-10 at 04:59 +0200, Jason A. Donenfeld wrote:
> Otherwise, we enable all sorts of forgeries via timing attack.

I'm not really sure that this is actually true, since you don't get
much feedback on your frame that's dropped, especially if you're
attacking from remote. Basically, I don't see how you can observe the
timing of this operation?

Anyway, applied.

johannes
