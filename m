Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4178C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F5EC2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfDZJbt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:31:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDZJbs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:31:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxCr-0007gm-74; Fri, 26 Apr 2019 11:31:45 +0200
Message-ID: <cd3c0dbd4f8d881c9da615504ad34612171377b2.camel@sipsolutions.net>
Subject: Re: [PATCHv5 2/9] nl80211: Add new netlink attribute for TID
 speicific retry count
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:31:44 +0200
In-Reply-To: <1553592550-15282-3-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
         <1553592550-15282-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-26 at 14:59 +0530, Tamizh chelvam wrote:
> 
> +	[NL80211_ATTR_TID_CONFIG_RETRY] = { .type = NLA_FLAG },
> +	[NL80211_ATTR_TID_CONFIG_RETRY_SHORT] = NLA_POLICY_MIN(NLA_U8, 1),
> +	[NL80211_ATTR_TID_CONFIG_RETRY_LONG] = NLA_POLICY_MIN(NLA_U8, 1),
> 
I guess it's a question of semantics, but for *TX retries* 0 should be
valid. Unless you're setting *TX attempts* (including the first one) but
that would be wrong...

So I guess you should clarify that in the documentation and really allow
0, which is sort of equivalent to no-ack but not really because it does
request an ACK.

johannes

