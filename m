Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:43663 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751653Ab2H0P2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:28:52 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Scalable approach for nl80211_feature_flags
Date: Mon, 27 Aug 2012 18:26:48 +0300
Message-ID: <122380019.CZjM6Zxjfs@lx-vladimir> (sfid-20120827_172856_237539_FFE894FD)
In-Reply-To: <1345967092.3622.2.camel@jlt4.sipsolutions.net>
References: <1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <3373913.UaOl7A5Fl4@lx-vladimir> <1345967092.3622.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There is 'new' approach for specifying various wifi driver flags,
using enum nl80211_feature_flags and wiphy.features.

Problem is, wiphy.features is u32, i.e. it is not scalable
beyond 32 flags.

I propose to re-define 'features' approach - convert it to
use 'bitmap' API like DECLARE_BITMAP for the 'features' and
use bit numbers rather then raw values in the
enum nl80211_feature_flags. Last value will be defined like
NL80211_FEATURE_MAX, and 'features' will auto-size using
DECLARE_BITMAP(features, NL80211_FEATURE_MAX);

Then, user space tools need to be modified as well.

If the direction looks correct, I'll go ahead to prepare patch.

Thanks, Vladimir.
