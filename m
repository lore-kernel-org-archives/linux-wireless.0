Return-Path: <SRS0=MKuk=4M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848EBC38BE0
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 18:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 624702084E
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 18:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBXS0w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:26:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXS0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Feb 2020 13:26:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6IRO-007MRm-5Q; Mon, 24 Feb 2020 19:26:50 +0100
Message-ID: <53190ece697ab7d9e83fdd667eaf9e05a4418193.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] Revert "mac80211: support
 NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_MAC_ADDRS"
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Cc:     Markus Theil <markus.theil@tu-ilmenau.de>
Date:   Mon, 24 Feb 2020 19:26:48 +0100
In-Reply-To: <c9fba32a-6959-a93a-3119-23915053538c@gmail.com> (sfid-20200224_181217_804461_2C765211)
References: <20200224101910.b87da63a3cd6.Ic94bc51a370c4aa7d19fbca9b96d90ab703257dc@changeid>
         <c9fba32a-6959-a93a-3119-23915053538c@gmail.com>
         (sfid-20200224_181217_804461_2C765211)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-02-24 at 10:56 -0600, Denis Kenzior wrote:

> So to me this patch set seemed like a good idea...  We (iwd) don't have 
> plans to support pre-auth in AP mode in the near future, so this revert 
> doesn't really affect us.  I do wonder what is the actual concern to 
> warrant a revert?

These are two entirely different things, preauth is simply real data as
far as the local system is concerned. It's not related to controlled
port operation at all, which this nl80211 API is about.

FWIW, you may have seen Markus's patch to remove preauth from the RX as
well, this won't work as is, but I'm still a bit on the fence as to
whether I'll force you into the right model or not (i.e. clear the
existing capability bit in mac80211, and introduce a new one that
doesn't report preauth over nl80211). For RX, however, the difference
isn't really that much of a big deal, so maybe just make it optional.

johannes

