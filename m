Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6EDC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8029220652
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8029220652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeI0CuX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:50:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46282 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbeI0CuX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 22:50:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5GX5-0004M5-FS; Wed, 26 Sep 2018 22:35:39 +0200
Message-ID: <1537994127.28767.39.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: add policy attribute range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 26 Sep 2018 22:35:27 +0200
In-Reply-To: <1537993066.28767.29.camel@sipsolutions.net> (sfid-20180926_221836_321005_FEBFE2B4)
References: <20180926200630.23399-1-johannes@sipsolutions.net>
         (sfid-20180926_220654_781731_7A389A4D) <1537993066.28767.29.camel@sipsolutions.net>
         (sfid-20180926_221836_321005_FEBFE2B4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 22:17 +0200, Johannes Berg wrote:
> On Wed, 2018-09-26 at 22:06 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Without further bloating the policy structs, we can overload
> > the `validation_data' pointer with a struct of s16 min, max
> > and use those to validate ranges in NLA_{U,S}{8,16,32,64}
> > attributes.
> > 
> > It may sound strange to validate NLA_U32 with a s16 max, but
> > in many cases NLA_U32 is used for enums etc. since there's no
> > size benefit in using a smaller attribute width anyway, due
> > to netlink attribute alignment; in cases like that it's still
> > useful, particularly when the attribute really transports an
> > enum value.
> 
> That said, I did find a few places where we could benefit from a larger
> type here - e.g. having a NLA_U16 that must be non-zero cannot be
> represented in the policy as is, since you can't set max to 65535.

We could also fix that, btw, by taking two bits out of the "type" field,
and letting those indicate "check_min" and "check_max". That would also
fix the other thing I noted regarding the union, I suppose.

I didn't really like that too much because it makes the whole thing far
more complex, but perhaps if we hide it behind macros like

#define NLA_POLICY_RANGE(tp, _min, _max) {
	.type = tp,
	.min = _min, .check_min = 1,
	.max = _max, .check_max = 1,
}

#define NLA_POLICY_MIN(tp, _min) {
	.type = tp,
	.min = _min, .check_min = 1,
}

#define NLA_POLICY_MAX(tp, _max) {
	.type = tp,
	.max = _max, .check_max = 1,
}

it becomes more palatable?

johannes
