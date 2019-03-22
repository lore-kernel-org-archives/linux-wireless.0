Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ABCC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B75221900
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfCVUu0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 16:50:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfCVUu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 16:50:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h7R7Q-0006Lo-U2; Fri, 22 Mar 2019 21:50:25 +0100
Message-ID: <eb3df21727c81ceed319b9106db895d735f4919d.camel@sipsolutions.net>
Subject: Re: preparing for 802.11ah channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     thomas <thomas@ibsgaard.io>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Mar 2019 21:50:24 +0100
In-Reply-To: <3ae333867edab6cc30e8154cce47ce3b4555fa43.camel@sipsolutions.net> (sfid-20190322_214648_821384_90E95590)
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
         <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
         <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com>
         (sfid-20190322_214016_716142_79489C2C) <3ae333867edab6cc30e8154cce47ce3b4555fa43.camel@sipsolutions.net>
         (sfid-20190322_214648_821384_90E95590)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-22 at 21:46 +0100, Johannes Berg wrote:
> 
> In effect, an existing
> 
> 	u32 freq;
> 
> would become
> 
> 	u32 freq, freq_fractional;
> 
> and we'd just treat the two as a 32.32 fixed point integer.

Maybe easier would be to say

	u32 freq;
	u16 freq_partial_khz;

and basically say

	freq_khz = freq * 1000 + freq_partial_khz;

Same reasoning and similar logic, but no need to do any sort of fixed
point conversions.

johannes

