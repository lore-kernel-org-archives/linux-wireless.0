Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2IYHmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 03:42:16 -0400
Message-ID: <1348558970.10041.20.camel@jlt4.sipsolutions.net> (sfid-20120925_094219_968248_75F7A380)
Subject: Re: [PATCH v3] cfg80211: Fix regulatory check for 60GHz band
 frequencies
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 25 Sep 2012 09:42:50 +0200
In-Reply-To: <1348558107.10041.19.camel@jlt4.sipsolutions.net> (sfid-20120925_092757_197809_8B558E03)
References: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1348558107.10041.19.camel@jlt4.sipsolutions.net>
	 (sfid-20120925_092757_197809_8B558E03)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-25 at 09:28 +0200, Johannes Berg wrote:
> On Sun, 2012-09-23 at 09:49 +0200, Vladimir Kondratiev wrote:
> > The current regulatory code on cfg80211 performs a check to
> > see if a regulatory rule belongs to an IEEE band so that if
> > a Country IE is received and no rules are specified for a
> > band (which is allowed by IEEE) those bands are left intact.
> > The current band check assumes a rule is bound to a band
> > if the rule's start or end frequency is less than 2 GHz
> > apart from the center of frequency being inspected.
> > 
> > In order to support 60 GHz for 802.11ad we need to increase
> > this to account for the channel spacing of 2160 MHz whereby
> > a channel somewhere in the middle of a regulatory rule may
> > be more than 2 MHz apart from either the beginning or
> 
> GHz?

Applied with that fix & a typo fix in the comments.

johannes

