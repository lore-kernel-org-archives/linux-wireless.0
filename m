Return-Path: <SRS0=1Ud/=BJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B183C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 11:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118482082E
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 11:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgG3LlO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jul 2020 07:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgG3LlN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jul 2020 07:41:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE3C061794
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2020 04:41:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k16vw-00DUsw-54; Thu, 30 Jul 2020 13:41:12 +0200
Message-ID: <20d23075fb3437874a311ac18aa94194118a6e2b.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: Add support to get BIP failure counters
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Vinita S. Maloo" <vmaloo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 30 Jul 2020 13:41:04 +0200
In-Reply-To: <1593498381-9337-1-git-send-email-vmaloo@codeaurora.org>
References: <1593498381-9337-1-git-send-email-vmaloo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-06-30 at 11:56 +0530, Vinita S. Maloo wrote:
> Add support to get number of MIC errors, missing MME incidents and
> packet replay incidents observed while using IGTK/BIGTK keys when
> PMF and/or beacon protection features are enabled.

I can imagine you need this for WFA tests, but why are the debugfs
counters not enough for that?

I don't really see much functional reason (wpa_supplicant or so) to have
this, and thus why expose it in the nl80211 API?

johannes


