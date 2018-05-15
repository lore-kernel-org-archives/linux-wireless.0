Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34062 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbeEOHAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 03:00:06 -0400
Message-ID: <1526367603.3255.3.camel@sipsolutions.net> (sfid-20180515_090009_980327_6151D6A5)
Subject: Re: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx
 statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sriram R <srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 May 2018 09:00:03 +0200
In-Reply-To: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-15 at 10:47 +0530, Sriram R wrote:
> This patchset adds support for the collection and propagating of
> per-rate, per-station rx statistics when enabled by a userspace application.
> 
> These statistics can be useful in understanding the quality of 
> communication with our peers and in evaluating how different peers
> are communicating in different MCS/BW/NSS during different time periods and environment.

So ... I know that you're aware of my rate statistics collection code
(at least you should be, I showed it to Jouni), so I think you should
state why that approach isn't suitable.

In particular, I don't like the idea that you implement here of allowing
unresponsive (or dead) userspace to let the data pile up indefinitely. I
think we should be sending it out upon reaching a threshold to limit the
memory consumption in the kernel more reliably.

johannes
