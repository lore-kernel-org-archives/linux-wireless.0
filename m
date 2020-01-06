Return-Path: <SRS0=OLg+=23=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A303C33C8C
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 17:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE2321744
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jan 2020 17:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgAFRpf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jan 2020 12:45:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:52206 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgAFRpe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jan 2020 12:45:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ioWRJ-000UZI-7p; Mon, 06 Jan 2020 18:45:17 +0100
Message-ID: <e99552c62deec285cd4796827d53cdb1187eaca4.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: remove object duplication in Makefile
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Mon, 06 Jan 2020 18:45:15 +0100
In-Reply-To: <CAK7LNARLw0cBBCV8C6_bKhxEmUSTqP2Ve1RWzUJw6y2cnqdUXQ@mail.gmail.com>
References: <20200106075439.20926-1-masahiroy@kernel.org>
         <8f17a0bca11604d9818326b01267186bd91236c9.camel@sipsolutions.net>
         <CAK7LNARLw0cBBCV8C6_bKhxEmUSTqP2Ve1RWzUJw6y2cnqdUXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-01-07 at 02:11 +0900, Masahiro Yamada wrote:

> iwlwifi-m is automatically handled since commit
> cf4f21938e13ea1533ebdcb21c46f1d998a44ee8
> but cfg/*.o objects are not liked to vmlinux
> under the following combination:
> 
> CONFIG_IWLWIFI=y
> CONFIG_IWLDVM=m
> CONFIG_IWLMVM=m

Right, that's what I thought.

> Perhaps, I may come back to this patch,
> but I need to change scripts/Makefile.lib beforehand.

It's a pretty special case, not really worth it IMHO...

johannes

