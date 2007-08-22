Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:65119 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbXHVUFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 16:05:12 -0400
Received: by mu-out-0910.google.com with SMTP id i10so383147mue
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2007 13:05:11 -0700 (PDT)
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Date: Wed, 22 Aug 2007 22:12:52 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222131.24882.IvDoorn@gmail.com> <200708222154.03663.m.kozlowski@tuxland.pl>
In-Reply-To: <200708222154.03663.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708222212.52805.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>   CC [M]  drivers/net/wireless/zd1211rw-mac80211/zd_mac.o
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: In function `zd_op_erp_ie_changed':
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: `IEEE80211_ERP_CHANGE_PREAMBLE' undeclared (first use in this function)
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:822: error: for each function it appears in.)
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c: At top level:
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: error: unknown field `erp_ie_changed' specified in initializer
> drivers/net/wireless/zd1211rw-mac80211/zd_mac.c:844: warning: initialization from incompatible pointer type
> make[4]: *** [drivers/net/wireless/zd1211rw-mac80211/zd_mac.o] Error 1
> make[3]: *** [drivers/net/wireless/zd1211rw-mac80211] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

I'm not a zd1211rw developer, but a quick look into the patch series it seems
that the mac80211 version in -mm1 does not contain the patch
[PATCH 4/4] mac80211: implement ERP info change notifications
But it does contain the zd1211rw patch:
[PATCH] zd1211rw-mac80211: use correct preambles for RTS/CTS frames
Which depended on the above mentioned mac80211 patch.

Just had a second thought about those rt2x00 compilation errors you reported,
the error is not caused by rt2x00 lagging behind mac80211 api changes but
that rt2x00 patches to follow the api changes are going upstream but
the mac80211 api changes it depends on are not going anywhere.

It seems that mac80211 has not been updated in the -mm tree while the
drivers have been updated. This is causing the compilation errors for both
rt2x00 as zd1211rw.
I'll bet that if you try any other mac80211 driver similar issues will arise.

Ivo
