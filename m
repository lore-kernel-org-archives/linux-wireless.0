Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37248 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab2H1JQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 05:16:27 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: Scalable approach for nl80211_feature_flags
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<3373913.UaOl7A5Fl4@lx-vladimir>
	<1345967092.3622.2.camel@jlt4.sipsolutions.net>
	<122380019.CZjM6Zxjfs@lx-vladimir>
Date: Tue, 28 Aug 2012 12:16:20 +0300
In-Reply-To: <122380019.CZjM6Zxjfs@lx-vladimir> (Vladimir Kondratiev's message
	of "Mon, 27 Aug 2012 18:26:48 +0300")
Message-ID: <871uir74wr.fsf@purkki.adurom.net> (sfid-20120828_111631_128287_CF2579CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> There is 'new' approach for specifying various wifi driver flags,
> using enum nl80211_feature_flags and wiphy.features.
>
> Problem is, wiphy.features is u32, i.e. it is not scalable
> beyond 32 flags.

And currently we have used 4 out of 32. During the 10 months it has
existed we have added four new flags, which makes it a rate of 2,5
months per flag. Based on this it takes over five years to fill
that u32. So I'm not really worried about that right now.

> I propose to re-define 'features' approach - convert it to
> use 'bitmap' API like DECLARE_BITMAP for the 'features' and
> use bit numbers rather then raw values in the
> enum nl80211_feature_flags. Last value will be defined like
> NL80211_FEATURE_MAX, and 'features' will auto-size using
> DECLARE_BITMAP(features, NL80211_FEATURE_MAX);
>
> Then, user space tools need to be modified as well.

Please take into account that the kernel needs to be backwards
compatible and you cannot just change an existing nl80211 attribute to
something else. IMHO this isn't worth the trouble, we manage with the
u32 just fine for now.

-- 
Kalle Valo
