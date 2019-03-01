Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F89C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 20:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C8FC20643
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 20:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="n17yeO/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfCAUnx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 15:43:53 -0500
Received: from 1.mo179.mail-out.ovh.net ([178.33.111.220]:45127 "EHLO
        1.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCAUnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 15:43:53 -0500
Received: from player729.ha.ovh.net (unknown [10.109.143.189])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id DBED011C843
        for <linux-wireless@vger.kernel.org>; Fri,  1 Mar 2019 21:43:50 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player729.ha.ovh.net (Postfix) with ESMTPSA id 8342B367990D;
        Fri,  1 Mar 2019 20:43:49 +0000 (UTC)
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1551473028;
        bh=YhglpXaOSQoi4mMxZDsGl3o5Ho2/5a6rVY+vWVT1QVU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=n17yeO/zJDnsw+4OHsPn3+ANeD9EwkvubL/6K7anK6bxJZru++UI/ORWz2DS0ilMl
         Hkw/ngeZWT7NUt3bU18p3JQBtb3UNWL8+9oCdRarfDmRCRZZTrvTfyvApGVi+tveuZ
         /4H9sowhmzbK/LlLv6mg64VWUo1bNAFXmrs0qCYE=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-4-alexander@wetzel-home.de>
 <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
 <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
 <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
 <767ada740d984e180d0ac799487722293a50367c.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <95ba87e8-d7d2-53ae-f2c8-d4656dc1d29a@wetzel-home.de>
Date:   Fri, 1 Mar 2019 21:43:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <767ada740d984e180d0ac799487722293a50367c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11062529538459507911
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvdehgddugeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>>> So here the reasoning for why I named them as they are and why I  prefer
>>> the names used in the patch.
>>> First, many drivers will handle SET_KEY and SET_KEY_RX_ONLY with the
>>> same code and not differentiate between those at all. Using EXT_as a
>>> prefix for the "normal" command is therefore a nice way to imply the
>>> command can only be used with Extended Key ID and still link it to the
>>> original command.
>>> But more important for me was the clash between what the command spells
>>> and what it does in the COMPAT mode: SET_KEY_RX_ONLY would then be used
>>> to install a TX only key which never can be used by the card for Rx.
>>> So I decided to rename it to EXT_SET_KEY, just indicating that this
>>> command adds a new key to the card for Extended Key ID and drop the
>>> confusing reference to Rx.
> Wait, what? In compat mode SET_KEY_RX_ONLY installs a TX-only key? Ah,
> you mean before you changed this.
> 
> Why don't we split out compat mode then?
> 
> But I see where you're coming from with the EXT_ now. I need to think of
> it less as an "extension" now, but as "extended key ID". I'm not really
> entirely sure that makes sense - even what we think of as "extended key
> ID" now might be the new normal soon? But then again the spec does the
> same thing.
> 
>>> Long story short: Using SET_KEY_RXONLY and SET_KEY_TX is not wrong, but
>>> I would rate them more confusing.
> Fair enough.

I've had second (or more like tenths..) thoughts about this API.
If you like any of the solutions below more than the others I'll use 
that in the next patch, of course...

In a nutshell, the point of EXT_SET_KEY is to install a key, prepare it 
for Tx but NOT use it for Tx. The driver can use it for Rx (NATIVE) or 
just do nothing with the (in COMPAT mode) Tx only key till mac80211 
starts using it for Tx later.

1) Assuming we keep the RX_ONLY key flag we could just drop EXT_SET_KEY 
and  use the "normal" SET_KEY with the flag moved to ieee80211_key_conf.
We really just want to install the key to the driver here, only drivers 
like ath10k need a way to figure out it must not be used for Tx.

2) We also can drop the Rx only flag/extra command and simply use 
SET_KEY. ath10k will then have to honor the keyID mac80211 prepared when 
it want to support Extended Key ID. (ath10k seems to need a firmware 
update either way, so that could be acceptable.)

That said I've now decided to simply name the calls in the next patch:
SET_KEY	
	-> no RX only flag!
SET_KEY_RX
	-> SET_KEY, only key must not be used for Tx
DISABLE_KEY,
	-> unchanged
ACTIVATE_KEY
	-> so far named EXT_KEY_RX_TX
DISABLE_KEY_RX
	-> so far named EXT_DISABLE_KEY_RX

We can then continue the discussion with a new patch and the other fixes 
in it when needed.
To really clean that up we would have to change the existing names to 
something like ADD_KEY, REMOVE_KEY. We could then name the new calls 
ADD_KEY_RX, ACTIVATE_KEY and DISABLE_KEY_RX. But that seems to be overkill.

Alexander

Alexander
