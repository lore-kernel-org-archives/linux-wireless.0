Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B0CC10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B8E52087F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfDHMXF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:23:05 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54048 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfDHMXF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:23:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDTIh-0006Ai-6l; Mon, 08 Apr 2019 14:22:59 +0200
Message-ID: <9240677794fecc4188038696e0eec8b94bd81377.camel@sipsolutions.net>
Subject: Re: [PATCH 06/16] mac80211_hwsim: make copying of ciphers safer by
 checking the length
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 08 Apr 2019 14:22:57 +0200
In-Reply-To: <20190315163634.17315-7-luca@coelho.fi> (sfid-20190315_173654_856707_608C8EE1)
References: <20190315163634.17315-1-luca@coelho.fi>
         <20190315163634.17315-7-luca@coelho.fi>
         (sfid-20190315_173654_856707_608C8EE1)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-15 at 18:36 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> Make sure the length of the ciphers we are copying never exceeds the
> space we have for storing them.  There is no risk of overcopying at
> the moment, because we check n_params before, but this makes this
> function safer in case someone changes something in the future.

I don't think this makes sense.

If anything, we should pass extack to mac80211_hwsim_new_radio() and do
the entire validation there, but doing the same thing twice in two
places just because of static checkers is useless.

johannes

