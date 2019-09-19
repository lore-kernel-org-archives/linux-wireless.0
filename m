Return-Path: <SRS0=v6pW=XO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A41C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 22:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEE31218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 22:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404749AbfISWFK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 18:05:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51468 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbfISWFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 18:05:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iB4Xy-0007p0-85; Fri, 20 Sep 2019 00:05:06 +0200
Message-ID: <54996f59d8fb8f0f766959672e3fb9681d6a09c9.camel@sipsolutions.net>
Subject: Re: Can Intel AX200 sniff UL OFDMA ?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tim Higgins <tim@smallnetbuilder.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Fri, 20 Sep 2019 00:05:03 +0200
In-Reply-To: <82af1531-6f53-364c-46ed-e011455e9c01@smallnetbuilder.com> (sfid-20190919_210904_523705_B45512FD)
References: <82af1531-6f53-364c-46ed-e011455e9c01@smallnetbuilder.com>
         (sfid-20190919_210904_523705_B45512FD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tim,


> I have been using the debug hw_sniffer_params file to tune the AX200 to a specific AID. This 
> works well for capturing OFDMA DL. But I have yet to capture any UL OFDMA frames, or at least I 
> don't think I have.
> 
> I am looking for QoS data frames that have HE_MU PPDU format. Is this correct?
> I can see plenty of HE_SU PPDU frames from STA to AP, but no HE_MU uplink.
> 
> Am I looking for the wrong thing or can the AX200 not sniff OFDMA UL?

UL OFDMA frames should be HE_TB PPDU format, not HE_MU. They can only be
sent as a response to trigger frames, so all the participants are
synchronized etc.

johannes

