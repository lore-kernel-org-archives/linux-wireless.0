Return-Path: <SRS0=yvfE=2B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7B8C2D0C4
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 08:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DAC320836
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 08:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfLKIgd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:36:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:46342 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfLKIgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Dec 2019 03:36:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iexTy-003VSa-Bd; Wed, 11 Dec 2019 09:36:30 +0100
Message-ID: <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 09:36:29 +0100
In-Reply-To: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> (sfid-20191210_214627_221076_8C5C32D1)
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         (sfid-20191210_214627_221076_8C5C32D1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
> Hi,
> 
> Since the GRO issue got fixed, iwlwifi has worked fine for me.
> However, on every boot, I get some warnings:
> 
> ------------[ cut here ]------------
> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208

Yeah, we've seen a few reports of this.

I guess I kinda feel responsible for this since I merged the AQL work,
I'll take a look as soon as I can.

johannes

