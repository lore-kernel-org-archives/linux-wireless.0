Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60204 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423225AbcFMNSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 09:18:05 -0400
Message-ID: <1465823880.10050.3.camel@sipsolutions.net> (sfid-20160613_151808_748113_8C92EA2C)
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Mon, 13 Jun 2016 15:18:00 +0200
In-Reply-To: <20160613130507.GA11074@localhost> (sfid-20160613_150522_731750_3B82E728)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
 <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com>
 <1465808939.2434.1.camel@sipsolutions.net>
	 <20160613130507.GA11074@localhost> (sfid-20160613_150522_731750_3B82E728)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-13 at 09:05 -0400, Bob Copeland wrote:
> 
> So I did just go and check the generated code for each of these cases
> and gcc didn't elide the subsequent if-test, at least on x86-64 and
> my compiler / build config.  Given http://lwn.net/Articles/342330, it
> seems possible, though.

It's not clear that's the same situation, since tun->sk is very likely
to have been an actual pointer, not an embedded thing like drv_priv.

However, with all this, I think I'd simply not take any chances - the
patch isn't exactly invasive and in some cases (for example the first
hunk of the patch) will even improve the code to the point where the
compiler could warn about uninitialized usage of the pointer when the
code gets modified to use it in case of !txq->sta.

I'd take it, but I guess it's Kalle's decision :)

johannes
