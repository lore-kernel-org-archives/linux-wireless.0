Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB554C43460
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 11:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82276108B
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 11:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbhDSLYZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbhDSLYV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Apr 2021 07:24:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9689C06174A
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2021 04:23:51 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lYS0K-00DkQm-DB; Mon, 19 Apr 2021 13:23:48 +0200
Message-ID: <f7ebb34a0c01b1652defa3929559997c9885c045.camel@sipsolutions.net>
Subject: Re: [PATCHv2] mac80211: fix NULL ptr dereference during mesh peer
 connection for non HE devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Abinaya Kalaiselvan <akalaise@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 19 Apr 2021 13:23:47 +0200
In-Reply-To: <1618483625-31097-1-git-send-email-akalaise@codeaurora.org>
References: <1618483625-31097-1-git-send-email-akalaise@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2021-04-15 at 16:17 +0530, Abinaya Kalaiselvan wrote:
> "sband->iftype_data" is not assigned with any value for non HE supported
> devices, which causes NULL pointer access during mesh peer connection
> in those devices. Fix this by accessing the pointer after HE
> capabilities condition check.
> 
> Fixes: 7f7aa94bcaf0 (mac80211: reduce peer HE MCS/NSS to own capabilities)
> Signed-off-by: Abinaya Kalaiselvan <akalaise@codeaurora.org>
> ---
> v2:
> * ieee80211_sta_he_cap structure instance is initialized.
> 
How about taking other feedback into account?

johannes

