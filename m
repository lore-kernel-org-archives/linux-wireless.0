Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:47768 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbcECHu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 03:50:56 -0400
Message-ID: <1462261852.25176.24.camel@strongswan.org> (sfid-20160503_095059_583451_31BBF222)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 May 2016 09:50:52 +0200
In-Reply-To: <1462258588.2251.1.camel@sipsolutions.net>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
	 <1462258588.2251.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > This allows a controlling namespace to create radios and move them
> > to other namespaces for communication.

> Neat.
> 
> I'm curious what the use case is?

We use a test environment for integration and regression testing, which
allows us to run our networked applications in a simulated environment
using many hosts. Something like [1], but based on the full set of
(nested) Linux Namespaces.

This has been working great to simulate wired networks (using veth and
bridges). But as it runs unprivileged using user namespaces, we have
hit these permission issues when we tried to integrate support for
wireless radios using (the very cool) mac80211_hwsim. hwsim allows us
to simulate complex wireless networks using an unmodified userspace
software stack.

> I'll need some time to review it, it'll likely have to wait until
> next week given our holiday here on Thursday (and I'm also off work
> tomorrow/Friday)

Ok, great, looking forward to your feedback.

Best regardsMartin

[1]https://wiki.strongswan.org/projects/strongswan/wiki/TestingEnvironment
