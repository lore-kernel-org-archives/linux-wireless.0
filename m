Return-Path: <SRS0=VRWf=CF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87987C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 13:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB62206F0
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 13:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgH0NFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Aug 2020 09:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgH0NE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Aug 2020 09:04:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C778AC061233
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2020 06:04:00 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kBHZP-00Bb7X-3b; Thu, 27 Aug 2020 15:03:59 +0200
Message-ID: <f74dcc5216cc5a9b14033ce3741216e8bdb88dbe.camel@sipsolutions.net>
Subject: Re: [PATCH V3 2/9] mac80211: add multiple bssid support to
 interface handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Date:   Thu, 27 Aug 2020 15:03:55 +0200
In-Reply-To: <20200812150050.2683396-3-john@phrozen.org>
References: <20200812150050.2683396-1-john@phrozen.org>
         <20200812150050.2683396-3-john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +	struct {
> +		struct ieee80211_vif *parent;
> +		struct list_head list;

Is there a lot of value in having a separate list, vs. iterating all
interfaces and checking the parent pointer?

And exposing the list to the driver seems like a bad idea anyway, they
can't really get locking right.

(to be continued, mail client is acting up)

johannes

