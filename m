Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49806 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933071AbdEVK5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 06:57:13 -0400
Message-ID: <1495450628.2653.14.camel@sipsolutions.net> (sfid-20170522_125721_988813_53F2F695)
Subject: Re: 4.12-RC2 BUG: scheduling while atomic: irq/47-iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: netdev@vger.kernel.org
Date: Mon, 22 May 2017 12:57:08 +0200
In-Reply-To: <a54f3f4f-2365-2154-ad18-82e4cd572aac@eikelenboom.it> (sfid-20170522_124945_484427_F6127CF5)
References: <a54f3f4f-2365-2154-ad18-82e4cd572aac@eikelenboom.it>
         (sfid-20170522_124945_484427_F6127CF5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-05-22 at 12:36 +0200, Sander Eikelenboom wrote:
> Hi,
> 
> I encountered this splat with 4.12-RC2.

Ugh, yeah, I should've seen that in the review.

Arend, please take a look at this. cfg80211_sched_scan_results() cannot
sleep, so you can't rtnl_lock() in there. Looks like you can just rely
on RCU though?

johannes
