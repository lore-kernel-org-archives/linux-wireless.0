Return-Path: <SRS0=BG2g=C6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE59C43463
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 06:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DA8207BC
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 06:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIUGvd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Sep 2020 02:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgIUGvc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Sep 2020 02:51:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1CAC061755
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2020 23:51:32 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kKFfc-00844o-9e; Mon, 21 Sep 2020 08:51:28 +0200
Message-ID: <21104fe9de252ecc993deb1a65a5b182f348dec8.camel@sipsolutions.net>
Subject: Re: [PATCH v2 15/22] mac80211: don't calculate duration for S1G
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Mon, 21 Sep 2020 08:51:19 +0200
In-Reply-To: <b9d1a036f2b10a640a3e88fd23fb8ef3@adapt-ip.com>
References: <20200831205600.21058-1-thomas@adapt-ip.com>
         <20200831205600.21058-16-thomas@adapt-ip.com>
         <d922fa0215d8617c92948e1ddee5d23f77610723.camel@sipsolutions.net>
         <b9d1a036f2b10a640a3e88fd23fb8ef3@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-09-20 at 23:03 -0700, Thomas Pedersen wrote:
> 
> > I'm not even sure I'd leave a TODO there ... just say
> > 
> > 	/* device is expected to do this */
> 
> Eventually it would be nice if mac80211 could calculate duration for 
> S1G? Do you know why it doesn't for HT/VHT?

I'm not sure it matters. It almost doesn't even matter for legacy
(CCK/OFDM) because devices practically always do it anyway?

And for HT/VHT it's just quite a bit more complicated, so we never
bothered, since it wasn't necessary.

It couldn't even really be done since there are A-MPDUs and other things
happening at a lower layer.

johannes

