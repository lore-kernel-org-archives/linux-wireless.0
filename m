Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52660 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaKQNUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 08:20:39 -0500
Message-ID: <1416230435.2031.5.camel@sipsolutions.net> (sfid-20141117_142041_989603_03055222)
Subject: Re: [PATCH] mac80211: fix 11b fragmentation rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Nov 2014 14:20:35 +0100
In-Reply-To: <CA+BoTQ=JAVb+ROVu2cVz=Rtvgtcb=16pK6fLOvCJNzn_L5v7og@mail.gmail.com> (sfid-20141117_140719_994177_97277096)
References: <1416223626-10980-1-git-send-email-michal.kazior@tieto.com>
	 <1416227346.2031.3.camel@sipsolutions.net>
	 <CA+BoTQ=JAVb+ROVu2cVz=Rtvgtcb=16pK6fLOvCJNzn_L5v7og@mail.gmail.com>
	 (sfid-20141117_140719_994177_97277096)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-17 at 14:07 +0100, Michal Kazior wrote:

> My hunch was right. Apparently this happens when I use my kernel
> .config with some debug stuff enabled. In case you're interested:
> 
>  * http://pastebin.com/7shTYtFy -- good
>  * http://pastebin.com/pxwdJ5hS -- panic

Yeah, not much of a surprise since the pointer might still be valid or
at least readable (even if the data there is garbage) ... if we get a
good pointer.

But we try to run with many debug options turned on anyway, so I don't
know why this showed up only recently. Maybe some unrelated changes
(compiler changing to load the pointer again, for example)

johannes

