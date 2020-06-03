Return-Path: <SRS0=zppH=7Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EA9C433DF
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 14:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D76B20738
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 14:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgFCONv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgFCONt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jun 2020 10:13:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B63AC08C5C0
        for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2020 07:13:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jgU9K-008j9L-Lh; Wed, 03 Jun 2020 16:13:46 +0200
Message-ID: <ea1507a76adb346dc46c934d2905ab055b0f9236.camel@sipsolutions.net>
Subject: Re: BUG: deadlock on flushing mgmt registrations update work
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>,
        linux-wireless@vger.kernel.org
Date:   Wed, 03 Jun 2020 16:13:44 +0200
In-Reply-To: <e8143f03-d4a7-16ee-2e9a-e8d676ffef6d@tu-ilmenau.de> (sfid-20200603_161057_505290_069F30A5)
References: <e8143f03-d4a7-16ee-2e9a-e8d676ffef6d@tu-ilmenau.de>
         (sfid-20200603_161057_505290_069F30A5)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-06-03 at 16:10 +0200, Markus Theil wrote:
> While running hostapd tests, the following deadlock showed up:
> 
> cfg80211_mgmt_registrations_update_wk locks the rtnl lock, which
> is already hold by nl80211 when going into __cfg80211_unregister_wdev,
> which flushes cfg80211_mgmt_registrations_update_wk.

Hah, at least the work item lockdep detection is still working ;)

(just the other day I was telling someone the story of how I added that)

I'll take a look tomorrow.

johannes

