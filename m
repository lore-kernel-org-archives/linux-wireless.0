Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201Ab2IDOa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:30:58 -0400
Message-ID: <1346769184.26638.7.camel@dcbw.foobar.com> (sfid-20120904_163102_572229_54D7C91D)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Tue, 04 Sep 2012 09:33:04 -0500
In-Reply-To: <1346768149.3737.29.camel@jlt4.sipsolutions.net>
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <E1T8tYj-00051o-3z@debian64.localnet>
	 (sfid-20120904_155321_955424_2D6B3F4B) <1346768149.3737.29.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 16:15 +0200, Johannes Berg wrote:
> On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
> 
> > As you feared: the firmware is corrupting incoming management
> > frames. However, it does so only when a rxkey was configured.
> > So as a possible trade-off, MFP will only be supported by p54,
> > when the firmware crypto offloading is relieved of his duties
> > (disabled). 
> > 
> > Note: Strictly speaking, it would be enough to no longer upload
> > any rx key which could affect management frames, as the firmware
> > does not decrypt any frames unless there is a fitting key candidate.
> 
> Right, however, that would kinda defeat the point. Unless ... maybe we
> can tell the driver if 11w is going to be used at all? If we did that,
> we could make it work in the set_key callback.
> 
> For now your patch looks good though.

We can't get this to happen without a module option?  Is there a way to
turn the crypto offloading off when we know we're connecting to a W
protected AP?

Dan

