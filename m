Return-Path: <SRS0=VRWf=CF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F97C433E1
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 12:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB9C22CF7
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 12:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgH0Mad (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Aug 2020 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgH0M33 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Aug 2020 08:29:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC1EC061264
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2020 05:29:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kBH1z-00BaPG-Ny; Thu, 27 Aug 2020 14:29:27 +0200
Message-ID: <3f8502b5e185e2d21fe50d9039524d0dc30a0d14.camel@sipsolutions.net>
Subject: Re: [PATCH V5 4/5] mac80211: add support for BSS coloring
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Date:   Thu, 27 Aug 2020 14:29:26 +0200
In-Reply-To: <20200826055650.1101224-4-john@phrozen.org> (sfid-20200826_075710_318035_1DE9E6C8)
References: <20200826055650.1101224-1-john@phrozen.org>
         <20200826055650.1101224-4-john@phrozen.org>
         (sfid-20200826_075710_318035_1DE9E6C8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-08-26 at 07:56 +0200, John Crispin wrote:
> 
> +	INIT_WORK(&sdata->color_change_finalize_work, ieee80211_color_change_finalize_work);

Here, for example.

But that wasn't why I replied again.

Do we really need a separate work? We already make quite a few
assumptions about this not happening in parallel with CSA, and so it
seems we could even reuse this bit of the code?


johannes

