Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D339BC3F2CD
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 15:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B07D12073D
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 15:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEP15 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:27:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:36386 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCEP15 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 10:27:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9sPj-001Ntd-1r; Thu, 05 Mar 2020 16:27:55 +0100
Message-ID: <e8f9c498f2c05313b71b645fee5fc2ba6b993f87.camel@sipsolutions.net>
Subject: Re: [PATCH 2/4] wmediumd: create dependency files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Bob Copeland <me@bobcopeland.com>
Date:   Thu, 05 Mar 2020 16:27:54 +0100
In-Reply-To: <20200305155407.9160bf08eb68.I572a908900222a0d2fbaf683b66acc266c5ad904@changeid> (sfid-20200305_155714_188193_7CD84122)
References: <20200305145655.67427-1-johannes@sipsolutions.net>
         <20200305155407.9160bf08eb68.I572a908900222a0d2fbaf683b66acc266c5ad904@changeid>
         (sfid-20200305_155714_188193_7CD84122)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-03-05 at 15:56 +0100, Johannes Berg wrote:
> 
> +DEPS := $(patsubst %.o,%.d,$(OBJECTS))
>  clean: 
> -	rm -f $(OBJECTS) wmediumd
> +	rm -f $(OBJECTS) $(DEPS) wmediumd
> +
> +-include *.d

Come to think of it, maybe that should just be

-include $(DEPS)

and then it doesn't have to change in the next patch ... I guess you can
change it, or keep it, or shout if you want me to resend :)

johannes

