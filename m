Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22732C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0AF020700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfBVIa0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:30:26 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:33246 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfBVIaZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 03:30:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx6Dv-0005Yz-4O; Fri, 22 Feb 2019 09:30:23 +0100
Message-ID: <7377d6a44d9238e90f9bde55bc96cdecb3a4e25a.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 02/12] nl80211/cfg80211: Extended Key ID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 09:30:20 +0100
In-Reply-To: <a0e99ac4-4c10-55e6-3ded-5bb5a3ddfb78@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-3-alexander@wetzel-home.de>
         <790f69239a9635c62c9349323c069e4ac9ad51c9.camel@sipsolutions.net>
         <a0e99ac4-4c10-55e6-3ded-5bb5a3ddfb78@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-17 at 20:19 +0100, Alexander Wetzel wrote:

> I don't see the problem but I may simply be to set on my way to see 
> it... So I'll just give an outline what's required of the API and how 
> this implementation meets those. Hoping that answers your question or 
> allowing you to pinpoint our differences in understanding. (I've added a 
>   more than really required, it may be useful for other discussions to 
> have that outlined in one piece, too.)

:-)

> Extended Key ID has only two requirements for the kernel API:
> 1) Allow a key to be used for decryption first and switch it to a 
> "normal" Rx/Tx key with a second call
> 
> 2) Allow pairwise keys to use keyids 0 and 1 instead only 0.

Right.

> "Legacy" key installs are using NL80211_CMD_NEW_KEY to install a new key 
> and are allow to mark a key for WEP or management  default usages via 
> NL80211_CMD_SET_KEY later.

Right.

> With Extended Key ID we stick to a similar approach: NL80211_CMD_NEW_KEY 
> is called to install the new key and nl80211_key_install_mode allows to 
> select between a "legacy" or "extended" key install: NL80211_KEY_RX_TX 
> for "legacy" or NL80211_KEY_RX_ONLY for "extended".

Ah. That's where the "EXT" came from in the mac80211 names :-) FWIW, I'm
not sure that makes sense. Yes, we think of it as an "extension" or
being "extended" now while we work on it, but ultimately it'll be a
simple part of the API. But I digress.

> NL80211_KEY_SWITCH_TX is only allowed with NL80211_CMD_SET_KEY and is 
> the only Extended Key ID action allowed for that function.

Yes, but what does it *do*? Your documentation said:

	Switch Tx to a Rx only, referenced by sta mac and idx.

but that seems backwards to me based on the above requirement:
	Allow a key to be used for decryption first and switch it to a
	"normal" Rx/Tx key with a second call.

IOW, you said we need to have the ability to first install RX-only, and
then switch the key to RX & TX. I'd have called this "ENABLE_TX" or
something like that. Or perhaps SWITCH_(ON_)TX if you're so inclined,
but the documentation should then say

	Switch key from RX-only to TX/RX, referenced by ...

no? That's what I meant by "the other way around".

> Any non-pairwise keys can only use NL80211_KEY_RX_TX which is of course 
> always the default and also allowed for "legacy" pairwise keys.

Right.

> A Extended Key Install will:
> 1) call NL80211_CMD_NEW_KEY with all the usual parameters of a new key 
> install plus the flag NL80211_KEY_RX_ONLY set.

So far makes sense.

> 2) Once ready will call NL80211_CMD_SET_KEY with flag 
> NL80211_KEY_SWITCH_TX to activate a specific key.

Also makes sense, but the documentation doesn't.

I think we should rename these perhaps

	NL80211_KEY_RX_TX - install key and enable RX/TX (default)
	NL80211_KEY_RX_ONLY - install unicast key for RX only
	NL80211_KEY_ENABLE_TX - enable TX for a previously installed 
				RX_ONLY key

I think?

About the ENABLE_TX vs. SWITCH_TX - we don't allow to switch TX *off*
again, only *on*, so I think "enable" makes more sense than "switch".

Anyway, my whole comment was only about the documentation text which
seemed backward or at least unclear to me.

> ok, I'll remove all the drive-by comment "cleanups".
> It (often) looks kind of untidy and not really worth separate patches 
> and I'm kind of responsible for (most) of them.. I see why you don't 
> want to see those fixed drive-by...
> 
> My understanding is now that we prefer to not change those and I'll 
> leave them alone.

I have no objection to even the most trivial cleanup patches going in
separately, and if you like multiple in a bigger "clean up this area"
patch, but here I think it detracts from the patch.

> Yes. Extended Key ID only allows to use Key ID 1 on top of the 
> established ID 0. See "IEEE 802.11 - 2016 9.4.2.25.4 RSN capabilities":
> 
> Bit 13: Extended Key ID for Individually Addressed Frames. This subfield 
> is set to 1 to indicate that the STA supports Key ID values in the range 
> 0 to 1 for a PTKSA and STKSA when the cipher suite is CCMP or GCMP. A 
> value of 0 indicates that the STA only supports Key ID 0 for a PTKSA and
> STKSA.

OK :)

johannes

