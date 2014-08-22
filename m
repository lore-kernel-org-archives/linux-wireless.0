Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39431 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbaHVBTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 21:19:24 -0400
Message-ID: <1408670355.4388.4.camel@jlt4.sipsolutions.net> (sfid-20140822_031927_553800_E78354D5)
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Fri, 22 Aug 2014 03:19:15 +0200
In-Reply-To: <877g21c3dd.fsf@kamboji.qca.qualcomm.com>
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	 <20140821124907.27159.64620.stgit@potku.adurom.net>
	 <1408626616.4388.0.camel@jlt4.sipsolutions.net>
	 <877g21c3dd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-08-21 at 17:40 +0300, Kalle Valo wrote:

> Heh, this has been a pretty long review period. To be honest I really
> would like to get this just out of my hands :) And we do have a need for
> this. When are you planning to implement that generic framework?

Soon (TM). We need it, so really, I should do it soon.

> What I understood is that this is already pretty close what you are
> planning. Instead of creating a debugfs file of our own and allocating a
> vmalloc buffer (which we do now), we would just use the buffer provided
> by cfg80211 (or whatever component that would be) and use the sysfs file
> the framework provides. So hopefully it would be pretty easy to convert
> this to use your framework.

I'm thinking now that since vmalloc space is limited on some
architectures, we should just have a list of pages, but of course we
could copy it there from vmalloc area.

Anyway, yes, it should be fairly simple to convert - but is it worth it
for you to have it now? Depends how you use it, I guess.

johannes

