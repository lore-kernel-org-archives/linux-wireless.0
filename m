Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37CEC433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 09:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA93F208DB
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 09:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgE1Jn7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 05:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgE1Jn6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 05:43:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889B5C05BD1E
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 02:43:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeF4u-004mBb-QX; Thu, 28 May 2020 11:43:56 +0200
Message-ID: <1e313010dd85af086dc0922a3faeaa0e1c6cc44f.camel@sipsolutions.net>
Subject: Re: [PATCH v3 06/11] mac80211: handle HE 6 GHz Capability in HE STA
 processing
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Date:   Thu, 28 May 2020 11:43:55 +0200
In-Reply-To: <1589399105-25472-6-git-send-email-rmanohar@codeaurora.org> (sfid-20200513_214550_120836_C3C5E2B4)
References: <1589399105-25472-1-git-send-email-rmanohar@codeaurora.org>
         <1589399105-25472-6-git-send-email-rmanohar@codeaurora.org>
         (sfid-20200513_214550_120836_C3C5E2B4)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

So I'm dropping this one for now.

I'm going to send a series right now with what I have, and you can start
looking at how to put this on top.

I'd prefer for *mac80211* to add the 6ghz capa sub-struct to the station
and use that while parsing, I think that should still be reasonable from
the driver's POV. You'll see I didn't change ieee80211_sta_he_cap, and I
am thinking now that it shouldn't change.

I'm still working on
 * the HE oper -> channel parsing (MLME, and you also had mesh)
 * 6 GHz scan bits that we had.

But I think you should be able to work on this patch without those two
things.

johannes

