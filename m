Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38926 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751401AbcIQOu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 10:50:59 -0400
Message-ID: <1474123851.7623.2.camel@sipsolutions.net> (sfid-20160917_165101_840724_FF7C5E9F)
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver
 for Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>, igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Date: Sat, 17 Sep 2016 16:50:51 +0200
In-Reply-To: <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> drivers/net/wireless/quantenna/qtnfmac/event.c: In function
> `qtnf_event_handle_scan_complete':
> drivers/net/wireless/quantenna/qtnfmac/event.c:342:2: warning:
> passing argument 2 of `cfg80211_scan_done' makes pointer from integer
> without a cast [enabled by default]

Yes, cfg80211_scan_done() changed fairly recently for sure.

> ./include/net/cfg80211.h:4104:6: note: expected `struct
> cfg80211_scan_info *' but argument is of type `u32'
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c: In function
> `qtnf_virtual_intf_cleanup':
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:1093:4: warning:
> passing argument 2 of `cfg80211_scan_done' makes pointer from integer
> without a cast [enabled by default]
> ./include/net/cfg80211.h:4104:6: note: expected `struct
> cfg80211_scan_info *' but argument is of type `int'
> 

These also seem related.

> > +F:   drivers/net/wireless/quantenna/qtnfmac

> The include directory is not listed.

Should really just stop after quantenna/ I'd think? As long as it's
just a single driver, you might as well claim maintenance over
everything there :)

> I guess some of these static variables could be also const, but
> didn't check.

I think both bitrates and channels can't be, due to cfg80211 writing
some (global) flags there on init.

johannes
