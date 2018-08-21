Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:57246 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbeHUMWZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:22:25 -0400
Message-ID: <1534842181.25523.1.camel@sipsolutions.net> (sfid-20180821_110309_343724_75A279F6)
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
From: Johannes Berg <johannes@sipsolutions.net>
To: Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 11:03:01 +0200
In-Reply-To: <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com> (sfid-20180821_082311_754636_51C1206C)
References: <20180820073705.9683-1-johannes@sipsolutions.net>
         <20180820102710.GA2760@redhat.com>
         <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
         (sfid-20180821_082311_754636_51C1206C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 08:23 +0200, Grzegorz Duszyński wrote:
> 
> I've applied the patch, but it does not seem to help.
> Spawning second instance of hostapd causes same error as before.

Ok, it was worth a try.

> I don't follow why this issue would not occur with single NIC.
> It's not like I am an expert in this field, but those rules should be 
> applied to both interfaces, right?
> Both interfaces use ath10k, that should imply same code path for setting 
> rules.

Yeah that's why I thought maybe the copy code was involved ...

I guess we'll need to try to reproduce. Maybe it can be made to happen
with hwsim too?

johannes
