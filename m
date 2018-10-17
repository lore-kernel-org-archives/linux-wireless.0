Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1042ECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 20:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BD602087A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 20:59:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BD602087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbeJRE4k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 00:56:40 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51678 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbeJRE4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 00:56:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCsuL-00028a-W5; Wed, 17 Oct 2018 22:59:10 +0200
Message-ID: <59ef2a794c49a6afdb5606f17b3cdc7c44594498.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] mac80211_hwsim: allow setting iftype support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 17 Oct 2018 22:58:55 +0200
In-Reply-To: <d7b8072e7648942738cac427b0b1f7005befc0c5.camel@linux.intel.com>
References: <20181017193307.1780-1-james.prestwood@linux.intel.com>
         <20181017193307.1780-2-james.prestwood@linux.intel.com>
         (sfid-20181017_212933_830456_E841649D) <48e12e055637af139094b6c1163f61c45b5ebb54.camel@sipsolutions.net>
         <d7b8072e7648942738cac427b0b1f7005befc0c5.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-17 at 14:00 -0700, James Prestwood wrote:
> 
> > That makes me wonder if you'd also want to support limiting the # of
> > interfaces/channels to mimic another device?
> 
> Yeah it seems like it would be pretty easy to add that on top of this
> change, although I don't really see us actually using it.

Sure, fair enough.

> I can add it,
> but my only concern is I would not test it up to the same level I
> tested iftype/ciphers. 

If you don't really want to use it, then I don't think you need to add
it. I was just wondering if it made a difference.

> Maybe this is also because I am not entirely
> sure what num_different_channels is doing. Is this only relevant when
> multiple interfaces exist on a radio? Like setting how many channels
> can be use simultaneously?

Correct. "Simultaneously" is a bit of an overstatement, typically today
it's implemented by TDM - if you have two interfaces with a connection
to an AP each, but on different channels, each interface would just tell
its AP that it's going to sleep, but instead hop to the other channel
and tell that AP that it woke up... etc.

johannes

