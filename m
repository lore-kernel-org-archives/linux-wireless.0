Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38147 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098AbcCHQzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 11:55:31 -0500
Message-ID: <1457456123.24270.11.camel@sipsolutions.net> (sfid-20160308_175543_459682_B199D46B)
Subject: Re: [PATCH] mac80211: Allow probe response frame rx to user space
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Mar 2016 17:55:23 +0100
In-Reply-To: <1457334731-6456-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1457334731-6456-1-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-03-07 at 12:42 +0530, Vasanthakumar Thiagarajan wrote:
> Especially during off-channel scan user space might be interested
> in probe reponse frames along with beacon to build a list
> of preferred channel and bssid which could be sent to the stations
> around for better spectrum management. Do not drop probe response
> frame in AP mode and advertise driver's capability to receive probe
> response frame in AP mode to user space.

I'm not convinced that this is a good idea - these frames will still
populate the BSS cache, and it's not really quite well-specified what
happens when you have both [1]

I also don't understand the use case; "might be interested" is ... very
vague.

johannes

[1] obviously, today you get both, but an argument could be made for
userspace RX meaning the frame has no action taken in the kernel, like
with action frames.
