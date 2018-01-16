Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57620 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeAPWYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 17:24:11 -0500
Message-ID: <1516141444.410.52.camel@sipsolutions.net> (sfid-20180116_232414_974047_9EC0E1C4)
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
Date: Tue, 16 Jan 2018 23:24:04 +0100
In-Reply-To: <5A5E5C99.5020607@broadcom.com> (sfid-20180116_211216_753091_08EEF52B)
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-6-pkshih@realtek.com>
         <871sip24fc.fsf@purkki.adurom.net> <5A5E5C99.5020607@broadcom.com>
         (sfid-20180116_211216_753091_08EEF52B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-16 at 21:12 +0100, Arend van Spriel wrote:
> 
> When I saw this flying by I had the same feeling. This is clearly not 
> how it was intended although you could interpret the comments of the 
> .set_frag_threshold() callback and IEEE80211_HW_SUPPORTS_TX_FRAG. 
> However, the fragmentation threshold is a user-configurable stack 
> parameter as per the standard. This patch effectively kill that option 
> for the user although there may be RF conditions in which fragmentation 
> can help. Having the user configure a fragmentation threshold of 2346 
> also disables fragmentation and allows mac80211 to use cached fastpath.
> 

        /* fast-xmit doesn't handle fragmentation at all */
        if (local->hw.wiphy->frag_threshold != (u32)-1 &&
            !ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG))
                goto out;

so internally at least it has to be -1, does 2346 really do that?
remember, but it might well :-)

johannes
