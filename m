Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49538 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965616AbeFOLGs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:48 -0400
Message-ID: <1529060806.10037.1.camel@sipsolutions.net> (sfid-20180615_130652_261827_23F81157)
Subject: Re: [PATCH] cfg80211: fix rcu in cfg80211_unregister_wdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2018 13:06:46 +0200
In-Reply-To: <001501d4031c$74710ac0$5d532040$@codeaurora.org> (sfid-20180613_154309_869062_57D69970)
References: <001501d4031c$74710ac0$5d532040$@codeaurora.org>
         (sfid-20180613_154309_869062_57D69970)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We believe this is due to cfg80211_unregister_wdev doing list_del_rcu()
> without synchronize_cpu() afterwards.

Looks like all callers behave like you described...

I've applied this, but next time please put the extra text after ---
below the Signed-off-by, and send patches that aren't whitespace damaged
:)

johannes
