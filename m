Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaATLGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 06:06:49 -0500
Message-ID: <1390216005.4335.19.camel@jlt4.sipsolutions.net> (sfid-20140120_120652_376515_5181947D)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Jan 2014 12:06:45 +0100
In-Reply-To: <CA+BoTQk62antiWbq7MxmjP_caj7xTOj699eiQO-TPFY32oX+5Q@mail.gmail.com> (sfid-20140116_113329_047866_CA32194F)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	 <1389792139.4338.6.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=UJNLD3dmzD4PDK1exSJFeWTdpkAHc2YvVbktugw_AyQ@mail.gmail.com>
	 <1389864706.4345.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk62antiWbq7MxmjP_caj7xTOj699eiQO-TPFY32oX+5Q@mail.gmail.com>
	 (sfid-20140116_113329_047866_CA32194F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 11:33 +0100, Michal Kazior wrote:

> If you assume a driver supports multi-channel but isn't capable of
> multi-interface CSA you'll be running into timing issues. After you
> detect radar you have a limited time to quiesce. You might end up
> exceeding that limit if you move APs one-by-one.

That probably won't work anyway since you could probably not move them
one by one anyway due to channel context limitations.

> With my patches as they are new hostap will try sending new channel
> switch command but since it doesn't contain ifindex old kernel will
> respond with a -EINVAL and userspace has no way of knowing if the
> command was actually malformed or isn't supported. hostap could still,
> however, work in a best effort manner and fallback to the old command
> variant.

Well, you're looking at it reactively. I was more thinking hostapd might
want to look at it proactively and, for example, refuse setting up
multiple BSSes on a radar channel if multi-switch isn't supported. But
for that, it has to know upfront rather than realizing it reactively
when trying to switch.

johannes

