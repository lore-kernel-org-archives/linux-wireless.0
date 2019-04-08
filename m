Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641D9C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3135A2063F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDHLy6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:54:58 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53532 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfDHLy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 07:54:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDSrY-0005b3-B8; Mon, 08 Apr 2019 13:54:56 +0200
Message-ID: <a9fc88ef5120ec1b744249b79269b338ea07b5bd.camel@sipsolutions.net>
Subject: Re: [PATCHv2 1/2] cfg80211: Add support to configure station
 specific RSSI threshold for AP mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 13:54:55 +0200
In-Reply-To: <1549361181-6237-2-git-send-email-tamizhr@codeaurora.org>
References: <1549361181-6237-1-git-send-email-tamizhr@codeaurora.org>
         <1549361181-6237-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-05 at 15:36 +0530, Tamizh chelvam wrote:
> 
> +	[NL80211_ATTR_CQM] = {
> +		.type = NLA_NESTED,
> +		.validation_data = nl80211_attr_cqm_policy,
> +	 },

This is wrong, you need to use NLA_POLICY_NESTED().

> +	[NL80211_ATTR_STA_MON_FIXED_THOLD] = { .type = NLA_U8 },

Please use NLA_POLICY_RANGE(NLA_U8, 0, 1).

Also, I'm not sure I really understand the documentation for this value.

>  	/* Check all values negative and sorted */
> -	for (i = 0; i < n_thresholds; i++) {
> +	for (i = 0; i < n_tholds; i++) {

Why rename the perfectly fine variable to some abbreviation?

johannes

