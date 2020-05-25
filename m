Return-Path: <SRS0=BuOi=7H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52CCC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 09:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFFEF20787
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 09:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgEYJX6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 May 2020 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389105AbgEYJX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 May 2020 05:23:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8FAC061A0E
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2020 02:23:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jd9Ku-002beb-3o; Mon, 25 May 2020 11:23:56 +0200
Message-ID: <ca2b26a87d49284a07b24c71046993814c4fe821.camel@sipsolutions.net>
Subject: Re: iwlwifi: 8265: unexpected LLC packets TX'ed in monitor mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marco Fonseca <marco@tampabay.rr.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 25 May 2020 11:23:55 +0200
In-Reply-To: <20200513174827.3o7odouinuirou62@192.168.1.10> (sfid-20200513_195606_809894_A3639A1D)
References: <20200513174827.3o7odouinuirou62@192.168.1.10>
         (sfid-20200513_195606_809894_A3639A1D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-05-13 at 13:48 -0400, Marco Fonseca wrote:
> Hello,
> 
> While in monitor mode, the 8265 will periodically transmit gratuitous
> LLC packets.  In this mode, I would expect the wifi chipset to not
> transmit any packets at all (unless packet injection is being used).
> 
> This behavior can be observed by a second wifi device in monitor mode.
> A display filter on wireshark/tshark of 'llc' makes these easy to spot.
> 
> It seems these packets only get produced in presence of a few APs
> and/or STAs but I'm not sure of the exact cause.  I don't see the LLC
> packets on very quiet channels.

I think these are somehow related to calibrations in the device.

johannes

