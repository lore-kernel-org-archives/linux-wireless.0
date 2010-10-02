Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0JBIpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 04:45:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: fix rx monitor filter refcounters
References: <201009281836.24529.chunkeey@googlemail.com>
	 <201009292157.04141.chunkeey@googlemail.com>
	 <1285790439.3756.35.camel@jlt3.sipsolutions.net>
	  <201010012353.21053.chunkeey@googlemail.com>
In-Reply-To: <201010012353.21053.chunkeey@googlemail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 02 Oct 2010 10:46:27 +0200
Message-Id: <1286009187.1646.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I'm fine with not allowing the cook flag to change,
> > seems like a pretty special case anyway. Or, we can
> > allow it to change, but only while the interface is
> > down, right?
> jup, works:
> 
> command failed: Function not implemented (-38), or should
> we use a different error code like -EBUSY/-EOPNOTSUPP?

I think typically I'd use ebusy, and I think it'd be more descriptive here?

> +        if (test_bit(SDATA_STATE_RUNNING, &sdata->state)) {

There's an inline for this, I think?

>   static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data

heh, by accident it's even in your patch :)

ACK with those two changes.

Johannes
