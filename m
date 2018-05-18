Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39482 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbeERJyf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:54:35 -0400
Message-ID: <1526637270.3805.15.camel@sipsolutions.net> (sfid-20180518_115440_197293_60E86CB5)
Subject: Re: [PATCH] ath10k: add dynamic vlan support
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Date: Fri, 18 May 2018 11:54:30 +0200
In-Reply-To: <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
         <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
         <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
         <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-05-04 at 12:20 +0530, Manikanta Pubbisetty wrote:
> Johannes,
> 
> It seems like commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on 
> crypto controlled devices") has broken 4-addr operation on crypto 
> controlled devices as reported by sebastian.
> The commit was mainly focused in addressing the problem in supporting 
> VLANs on crypto controlled devices but since 4-addr mode is also 
> dependent on AP_VLAN interface, this commit breaks the 4-addr AP mode.

Ok.

Do you know why it actually broke it? I mean, we should've turned off
the strict requirement for sw crypto control only for the GTK, and that
shouldn't matter so much?

> I have couple of ideas on how to address the problem,
> 
> 1) Add a new hw_flag and based on the hardware flag, allow/disallow the 
> creation of AP_VLAN interface.
> 
> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
> + *     operations in the BSS.

Based on the name and initial description, this sounds equivalent to
just turning off SW_CRYPTO_CONTROL. I think that's not the intent, but
would need some renaming.

> 2) Allow mac80211 to call set_key for GTKs on AP_VLAN interfaces for 
> crypto controlled devices, let the driver decide whether to return '1' 
> or some error code based on their support for transmitting sw encrypted 
> frames. I am little skeptical with this approach as drivers are totally 
> unaware of AP_VLAN interfaces.

No, that won't work.

I'm unsure how 4-addr VLAN can work with ath10k either way?

Maybe it just doesn't normally need a GTK, so nothing broke before, but
your other patch changed things to remove VLAN and then of course it's
no longer available?

But then I don't understand the complaint that 

So maybe the solution should be to add a separate flag for whether or
not 4-addr VLAN is supported?

johannes
