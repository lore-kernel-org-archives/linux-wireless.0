Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45634 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbdBXMxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 07:53:50 -0500
Message-ID: <1487938277.2540.13.camel@sipsolutions.net> (sfid-20170224_135422_921176_693FB39C)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 13:11:17 +0100
In-Reply-To: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com> (sfid-20170221_224703_956817_094A0B1B)
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
         (sfid-20170221_224703_956817_094A0B1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I have been trying to get basic WoWLAN to work with the following
> configuration:
> - Intel Corporation Wireless 7260 (rev 73) with in-tree iwlwifi
> driver

So I just tried on 4.9 with a 6205 NIC and it works there. The
difference must be somewhere in mvm/d3.c then, I guess. I got a lot of
warnings at resume time though, not sure why.

> However, when trying to suspend to RAM ( echo mem > /sys/power/state
> ), I get:
> [46656.403767] dpm_run_callback(): wiphy_suspend+0x0/0x97 [cfg80211]
> returns -16
> [46656.403769] PM: Device phy0 failed to suspend async: error -16
> 

However, I don't see EBUSY anywhere there in the driver.

Can you recompile the kernel and run a quick experiment?

Open drivers/net/wireless/intel/iwlwifi/mvm/mvm.h and put something
like this after the includes:

#undef EBUSY
#define EBUSY ({ WARN_ON(1); 16; })

that should trigger a warning at the place where the EBUSY came from,
assuming it did in fact come from the driver. You could repeat it for
net/mac80211/ieee80211_i.h if that doesn't trigger.

> https://bugzilla.kernel.org/show_bug.cgi?id=109591#c25

That device is like mine, afaict, so this seems to be a different bug.

johannes
