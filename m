Return-Path: <SRS0=CXG1=6E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AD0C55182
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Apr 2020 21:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384D1207FC
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Apr 2020 21:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgDTVSn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Apr 2020 17:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgDTVSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Apr 2020 17:18:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDDDC061A0C
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2020 14:18:42 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jQdoN-00CxS6-J3; Mon, 20 Apr 2020 23:18:39 +0200
Message-ID: <7b629e3d1aac2057c37ecc207e7154c3a0bd891b.camel@sipsolutions.net>
Subject: Re: [RFC] mac80211: Process multicast RX registration for Public
 Action frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 20 Apr 2020 23:18:38 +0200
In-Reply-To: <20200420205055.15573-1-jouni@codeaurora.org>
References: <20200420205055.15573-1-jouni@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-04-20 at 23:50 +0300, Jouni Malinen wrote:
> 
> + * @rx_multicast_reg: multicast Public Action frames should be reported to
> + *	mac80211 for this interface.

Since this is pretty specific ("multicast Public Action"), ...


> +	local->rx_multicast_reg = upd->global_mcast_stypes;

Maybe that should be a bit more specific and select only action subtype?
 
I guess I'd kinda prefer to document action, not just public action too,
since that's the granularity we have in the API now? I mean, public
action may be all we need now, but ...

johannes

