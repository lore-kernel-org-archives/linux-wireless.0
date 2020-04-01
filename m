Return-Path: <SRS0=eag0=5R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B896C43331
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 07:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2B22073B
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 07:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgDAHI6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Apr 2020 03:08:58 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33566 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731792AbgDAHI6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Apr 2020 03:08:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jJXUe-00BTOj-6C; Wed, 01 Apr 2020 09:08:56 +0200
Message-ID: <e824f5f31e1fd2559d8416ee1f17597cff21c693.camel@sipsolutions.net>
Subject: Re: [RFC 4/7] mac80211: add freq_offset to RX status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Wed, 01 Apr 2020 09:08:55 +0200
In-Reply-To: <20200401062150.3324-5-thomas@adapt-ip.com>
References: <20200401062150.3324-1-thomas@adapt-ip.com>
         <20200401062150.3324-5-thomas@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-31 at 23:21 -0700, Thomas Pedersen wrote:
> RX status needs a KHz component, so add freq_offset. We
> can make ampdu_reference u16 since it is probably
> sufficient to be able to distinguish 64k different
> A-MPDUs.

Is that necessary? Reads like we have 2 bytes free there?

And we only need 13 bits for the frequency (up to 8192 MHz, 60 GHz isn't
supported), so we could take out a few fractional ones for the S1G part?

Dunno, I mean, we probably also don't need the A-MPDU reference, even
radiotap doesn't make much representation on this, but it sort of
implies that it should be unique in a capture file, for which 16 bits
wouldn't be enough? (should probably clarify that though and say that
you should look only "close by" or something?)

johannes

