Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35516 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0IPSWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:22:22 -0400
Received: by gyd8 with SMTP id 8so482235gyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 11:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100916125927.163519598@sipsolutions.net>
References: <20100916125821.369545798@sipsolutions.net> <20100916125927.163519598@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Sep 2010 11:22:01 -0700
Message-ID: <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: add p2p device type support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 5:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When a driver advertises p2p device support,
> mac80211 will handle it, but internally it will
> rewrite the interface type to STA/AP rather than
> P2P-STA/GO since otherwise a lot of paths need
> to be touched that are otherwise identical. A
> p2p boolean tells drivers whether or not a given
> interface will be used for p2p or not.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

While at it can you add a is_beaconing_iftype() or something, that
should reduce code and make it easier to check for these modes.

  Luis
