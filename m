Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53724 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbeARKJv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 05:09:51 -0500
Message-ID: <1516270185.410.56.camel@sipsolutions.net> (sfid-20180118_110955_624415_05AAD7C1)
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Pkshih <pkshih@realtek.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc: =?UTF-8?Q?=E8=8E=8A=E5=BD=A5=E5=AE=A3?= <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Date: Thu, 18 Jan 2018 11:09:45 +0100
In-Reply-To: <1516266330.3990.6.camel@realtek.com>
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-6-pkshih@realtek.com>
         <871sip24fc.fsf@purkki.adurom.net> <5A5E5C99.5020607@broadcom.com>
         (sfid-20180116_211216_753091_08EEF52B) <1516141444.410.52.camel@sipsolutions.net>
         <1516266330.3990.6.camel@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-18 at 09:05 +0000, Pkshih wrote:
> 
> >         /* fast-xmit doesn't handle fragmentation at all */
> >         if (local->hw.wiphy->frag_threshold != (u32)-1 &&
> >             !ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG))
> >                 goto out;
> > 
> 
> Thank you for this point. This commit has not to set SUPPORTS_TX_FRAG, 
> but only set SUPPORT_FAST_XMIT. I'll test and prepare for next 
> submission.

But the point is that you *shouldn't* set SUPPORTS_TX_FRAG, and then
fast-xmit will only get used for non-fragmented setups, which
realistically is all anyone cares about anyway.

johannes
