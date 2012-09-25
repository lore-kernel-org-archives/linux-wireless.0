Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2IYH1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 03:27:53 -0400
Message-ID: <1348558107.10041.19.camel@jlt4.sipsolutions.net> (sfid-20120925_092757_197809_8B558E03)
Subject: Re: [PATCH v3] cfg80211: Fix regulatory check for 60GHz band
 frequencies
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 25 Sep 2012 09:28:27 +0200
In-Reply-To: <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-23 at 09:49 +0200, Vladimir Kondratiev wrote:
> The current regulatory code on cfg80211 performs a check to
> see if a regulatory rule belongs to an IEEE band so that if
> a Country IE is received and no rules are specified for a
> band (which is allowed by IEEE) those bands are left intact.
> The current band check assumes a rule is bound to a band
> if the rule's start or end frequency is less than 2 GHz
> apart from the center of frequency being inspected.
> 
> In order to support 60 GHz for 802.11ad we need to increase
> this to account for the channel spacing of 2160 MHz whereby
> a channel somewhere in the middle of a regulatory rule may
> be more than 2 MHz apart from either the beginning or

GHz?

> end of the frequency rule.
> 
> Without a fix for this even though channels 1-3 are allowed world
> wide on the rule (57240 - 63720 @ 2160), channel 2 at 60480 MHz
> will end up getting disabled given that it is 3240 MHz from
> both the frequency rule start and end frequency. Fix this by
> using 2 GHz separation assumption for the 2.4 and 5 GHz bands
> but for 60 GHz use a 10 GHz separation before assuming a rule
> is not part of the band.

Luis, given that you think the regulatory code in the kernel is 802.11
specific, why are we inferring these rules from the frequencies rather
than using the 802.11 specific information about the band that it
represents? :-D

johannes

