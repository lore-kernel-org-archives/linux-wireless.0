Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48144 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757187AbdACHGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 02:06:21 -0500
Message-ID: <1483427177.15591.5.camel@sipsolutions.net> (sfid-20170103_080624_699624_2C6703B1)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Tue, 03 Jan 2017 08:06:17 +0100
In-Reply-To: <CACna6ryrYY5G=Fvmsrq_sD3iX5dWreyz7R8mGEd6ogUck=twnQ@mail.gmail.com> (sfid-20170102_231255_379430_96267468)
References: <20170102163209.2445-1-zajec5@gmail.com>
         <20170102163209.2445-2-zajec5@gmail.com>
         <1483379548.15591.1.camel@sipsolutions.net>
         <CACna6ryrYY5G=Fvmsrq_sD3iX5dWreyz7R8mGEd6ogUck=twnQ@mail.gmail.com>
         (sfid-20170102_231255_379430_96267468)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When driver uses custom regulatory it registers initial channels at
> init but it can also react to regdom changes using reg_notifier. Is
> that correct?

We can treat regulatory and OF data as entirely independent, I think.
At least that's my suggestion:

 * use OF data to populate the original channel list, saying which
   channels are valid (or not)
 * use regulatory later to further restrict settings of the channels

> So I'm looking at brcmf_cfg80211_reg_notifier which calls
> brcmf_setup_wiphybands which calls brcmf_construct_chaninfo.
> That last one reworks all channels on every call. It first marks all
> existing channels as DISABLED then queries firmware for the list of
> supported channels and updates wiphy channels one by one.
> So if I understand this correctly, every regdom change can result in
> rebuilding channels pretty much from the scratch. That's why I
> believed I need to call wiphy_freq_limits_apply on runtime, not just
> during the init.
> 
> Is there some flow in my understanding?

I think maybe there's a problem in my understanding :)

All the regulatory code usually takes into account channel->orig_flags. 
If this code also did, then we could have the original DISABLED flag
taken from OF still be valid here.

johannes

johannes
