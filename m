Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3CSSZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:25:03 -0400
Message-ID: <1363717491.8336.1.camel@jlt4.sipsolutions.net> (sfid-20130319_192509_147606_ADFA0E85)
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 19 Mar 2013 19:24:51 +0100
In-Reply-To: <20130318213833.GA25758@gobelin> (sfid-20130318_223844_337753_ED6CE2B4)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
	 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
	 <1363634710.8260.15.camel@jlt4.sipsolutions.net>
	 <20130318213833.GA25758@gobelin> (sfid-20130318_223844_337753_ED6CE2B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 22:38 +0100, Karl Beldan wrote:

> > However this already exists in cfg80211.h --
> > cfg80211_chandef_identical().
> > 
> cfg80211_chandef_identical() will compare the whole chandef whatever the
> channel width.

As it should, a chandef where the unused fields are random isn't even
valid and will cause warnings left and right. That's a deliberate design
choice to simplify usage.

johannes

