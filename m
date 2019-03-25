Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE84C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF4220863
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfCYIrX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:47:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36584 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbfCYIrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 04:47:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h8LGK-0004tN-Vf; Mon, 25 Mar 2019 09:47:21 +0100
Message-ID: <7e9aff681ec9841e8a5b95384a7d1ba5eb617321.camel@sipsolutions.net>
Subject: Re: preparing for 802.11ah channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     thomas <thomas@ibsgaard.io>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 25 Mar 2019 09:47:19 +0100
In-Reply-To: <CABWD38nXRk5d7LPafnt9dvXc6nxFrEzeoDEREbdswga+WjpEMw@mail.gmail.com> (sfid-20190322_232917_265291_7D44CE45)
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
         <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
         <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com>
         <3ae333867edab6cc30e8154cce47ce3b4555fa43.camel@sipsolutions.net>
         <eb3df21727c81ceed319b9106db895d735f4919d.camel@sipsolutions.net>
         <CABWD38nXRk5d7LPafnt9dvXc6nxFrEzeoDEREbdswga+WjpEMw@mail.gmail.com>
         (sfid-20190322_232917_265291_7D44CE45)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-22 at 15:29 -0700, thomas wrote:
> 
> I guess it's a tradeoff between leaving MHz-only drivers alone and
> wrapping existing assignments and comparisons in maybe a macro to
> extract the final KHz value. The current set of changes is about 150
> lines in net/mac80211/ and net/wireless/ [1] with drivers/ being about
> the same.
> 
> Adding the KHz part to center_freq, center_freq1, and rx_status->freq
> may be fewer overall changes in mac80211 and cfg80211, and should be
> none for existing drivers.

Yes. I was also thinking that perhaps keeping "MHz-mostly" would lead in
less overall new binary size, since you don't need to do "/1000" in that
many places. I can't see it any more, but IIRC your patch did add a
number of "KHZ_TO_MHZ()" or so?

johannes

