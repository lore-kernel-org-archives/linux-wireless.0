Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42098 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbbEPT5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 15:57:12 -0400
Message-ID: <1431806229.2120.6.camel@sipsolutions.net> (sfid-20150516_215716_331653_5302EBE1)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 16 May 2015 21:57:09 +0200
In-Reply-To: <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com> (sfid-20150516_201855_046994_2FA7ED12)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 <1431674716.2426.2.camel@sipsolutions.net>
	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	 <1431714949.2117.0.camel@sipsolutions.net>
	 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
	 (sfid-20150516_201855_046994_2FA7ED12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-16 at 21:18 +0300, Emmanuel Grumbach wrote:

> I don't get it. I might have misunderstood your previous mail, but I
> thought that you were saying the key index was meant to solve this:
> the peer could know what key was used based on the key index written
> in the frame (I guess it is there somehow) so that the Rx handling
> code can know that the jump in the PN is due to a rekeying and not use
> any heuristic. I though you meant that the Txing side had a poor
> implementation because it reused the same key index before and after
> the rekeying which can obviously lead to problems.
> Now you seem to say that changing the key index upon rekeying is not
> allowed by spec?
> What is it good for then?

The key index is used for GTK rekeying. The spec makes no provision for
seamless PTK rekeying, it's simply not supported.

There was/is work in progress to actually change that, but I haven't
seen anything definitive. Jouni might know more.

> Again - I am just trying to close this bug, not to learn this subject.
> I can learn by reading spec / reading code and less by wasting your
> time :)

As I said, I believe at this point the only way to fix this bug is to
try to drop *old* key packets immediately, but it's difficult to ensure
this. Effectively, it would require synchronising RX vs. key
installation.

Using SW crypto will avoid this problem, because as I described in my
first email, the only reason (I can think of anyway) is that there's a
race between HW decrypt and SW key install. In the case of SW crypto,
there's a definitive link between the actual key and the PN because the
frame would fail to decrypt (and thus be dropped) if the wrong key was
used. The problem only happens in HW crypto with software PN because the
two are linked by the key index only.

This (entirely untested) patch might also help:
http://p.sipsolutions.net/3f082fae8a023bbc.txt

johannes

