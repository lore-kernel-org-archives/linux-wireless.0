Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7984AC433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 14:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E0D6115A
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Sep 2021 14:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhIVObM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhIVObK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Sep 2021 10:31:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA58FC061574;
        Wed, 22 Sep 2021 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=E/v1G6wKApDUxMisusgbCQBxHiITResHhLiWYoZ2Vgw=;
        t=1632320980; x=1633530580; b=QT+10sVmopf/3IxpJ1SG2V8Eaoxp4mMu7v98kGP54sq/Ge/
        SqUhUPaL2df2r5I6V480TDfGq5K/VeETrQ3C+3alymOhxcgTX9x7FwDGnXR/DrVGX5ipQBxDV7eiL
        UXtcEtCjFJ7Fxa7ZHdjrwzEjsItw/lLf7nb3XHBiq7YaT5UVgochpjZm4LnmKhF9xrNhtnaAgVg60
        w46v95TbRJInFqg2hYjxv5LaN7mS7u0YXscwop6UI7EbnJO6uUIGzA+DlE+doJNUGuTX1gTOkrDkV
        MLi34yrYkOj6nYv0v8tNnf9SkpEuwCs8G2BC1dJhnnix2XfAtGdfmec57F4aLukA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mT3Fi-00AKVc-Jc;
        Wed, 22 Sep 2021 16:29:38 +0200
Message-ID: <167f632eb19944b5711a584218e57b51da85df96.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: enable 6GHz channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Wed, 22 Sep 2021 16:29:37 +0200
In-Reply-To: <20210922142803.192601-1-ramonreisfontes@gmail.com>
References: <20210922142803.192601-1-ramonreisfontes@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-09-22 at 11:28 -0300, Ramon Fontes wrote:
> This adds 6 GHz capabilities and reject HT/VHT
> 

It'd be nice to add a version to the subject, with -vN on the git-send-
email commandline :)

> +		.he_6ghz_capa = {
> +			.capa = IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START |
> +			        IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP |
> +			        IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN |
> +			        cpu_to_le16(IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
> +			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS),

Seems that needs to be around the *entire* initializer, not just parts
thereof?

The indentation could also use some work :)

johannes

