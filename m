Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960D9C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62B4B207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfBVIxN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:53:13 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:33476 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBVIxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 03:53:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx6Zz-00062t-Ag; Fri, 22 Feb 2019 09:53:11 +0100
Message-ID: <b963b4257bba8b5423b93dd58c5828604fc07df4.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 04/12] mac80211: Compatibility Extended Key ID
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 09:53:08 +0100
In-Reply-To: <bad49ffb-5334-03f5-62e0-4f06d7c36242@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-5-alexander@wetzel-home.de>
         <0519f25cf73d8a91202e40b08e94de8d2520411e.camel@sipsolutions.net>
         <bad49ffb-5334-03f5-62e0-4f06d7c36242@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-21 at 21:07 +0100, Alexander Wetzel wrote:
> > 
> > > +	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> > > +		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
> > > +		/* Activate Rx crypto offload after max 10s when idle */
> > > +		ieee80211_queue_delayed_work(&local->hw, &sta->ext_key_compat_wk,
> > > +					     round_jiffies_relative(HZ * 10));
> > > +	}
> > 
> > Is there much point in this?
> > 
> > > +		if (unlikely(rx->key->flags & KEY_FLAG_RX_SW_CRYPTO)) {
> > > +			rx->key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
> > > +			cancel_delayed_work(&rx->sta->ext_key_compat_wk);
> > > +			ieee80211_queue_delayed_work(&rx->local->hw,
> > > +						     &rx->sta->ext_key_compat_wk, 0);
> > > +		}
> > 
> > We'll almost certainly do it from here, so never exercise the other
> > path?
> 
> This is mostly to have a definite time we know the new key is used also 
> for RX. In probably 99.9% of all cases it will be triggered from the Rx 
> path.
> Some special purpose devices may not send any packets for a long time 
> and trigger the fallback, as (wrong) firewall rules. (I've e.g. tested 
> it by dropping all outgoing packets on the remote sta.)
> 
> The idea was to be sure that a rekey intervall >10s prevents activating 
> Rx crypt when rekeying the next key. Which now sounds kind of thin...

Not sure I even understand this?

You meant "Rx crypto offload"? I'm not really sure we _care_ that much?

Then again, an issue may be that some firmware may want (need) the keys
for RX so it can look at certain frames (action frames?) itself. So if
we never install the RX key and then only get an action frame that the
firmware should handle, we lose. Such firmware could not support COMPAT
mode then I guess, which may mean a bunch of iwlwifi devices shouldn't
use COMPAT mode.

johannes

