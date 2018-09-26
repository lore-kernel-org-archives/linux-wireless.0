Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA90C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E608F2150B
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E608F2150B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbeI0CYe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:24:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46012 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbeI0CYe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 22:24:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5G8C-0003y5-9h; Wed, 26 Sep 2018 22:09:56 +0200
Message-ID: <1537992583.28767.24.camel@sipsolutions.net>
Subject: Re: [RFC] nl80211: use policy range validation where applicable
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 26 Sep 2018 22:09:43 +0200
In-Reply-To: <20180926200731.23491-1-johannes@sipsolutions.net> (sfid-20180926_220807_433903_259DD5BE)
References: <20180926200630.23399-1-johannes@sipsolutions.net>
         <20180926200731.23491-1-johannes@sipsolutions.net>
         (sfid-20180926_220807_433903_259DD5BE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 22:07 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Many range checks can be done in the policy, move them
> there. A few in mesh are added in the code (taken out of
> the macros) because they don't fit into the s16 range in
> the policy validation.

Forgot to say - this saves 550 bytes of .text on x86-64 for me.

johannes
