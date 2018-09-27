Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681BDC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D79621546
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D79621546
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbeI0QAj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:00:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53670 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbeI0QAj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:00:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5SpE-0000yi-O4; Thu, 27 Sep 2018 11:43:12 +0200
Message-ID: <1538041380.14416.26.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211: Fix possible Spectre-v1 for CQM RSSI
 thresholds
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Masashi Honma <masashi.honma@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 27 Sep 2018 11:43:00 +0200
In-Reply-To: <26b99a9d-85c1-ea9a-cb9e-0dc7bf9eb467@gmail.com> (sfid-20180927_002653_715119_DE765A63)
References: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
         <1537841701-3092-2-git-send-email-masashi.honma@gmail.com>
         <1537953785.28767.7.camel@sipsolutions.net>
         <26b99a9d-85c1-ea9a-cb9e-0dc7bf9eb467@gmail.com>
         (sfid-20180927_002653_715119_DE765A63)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-27 at 07:26 +0900, Masashi Honma wrote:
> On 2018/09/26 18:23, Johannes Berg wrote:> I applied the first patch in 
> the seies, but I don't understand why this
> > patch should be necessary.
> > 
> > The value of i isn't controlled by the user, so it shouldn't need to be
> > sanitized?
> > 
> > The context was *just* missing, added by me:
> > 
> >          for (i = 0; i < n; i++)
> > >   		if (last < wdev->cqm_config->rssi_thresholds[i])
> > >   			break;
> > 
> > This loop determines i, and the user doesn't even control "last", but
> > even if they did, the possible values of i could only end up being in
> > the range 0..n-1, so no problems?
> 
> The variable i could be n after the loop when this condition is not 
> satisfied for all rssi_thresholds[i].
> 
>  >>   		if (last < wdev->cqm_config->rssi_thresholds[i])
>  >>   			break;
> 
> And user could control rssi_thresholds[i] by using 
> NL80211_ATTR_CQM_RSSI_THOLD.
> 
> For example, I could set 4 rssi_thresholds -400, -300, -200, -100.
> And then last is -34. I could get i = n = 4 after the loop.

Yes, good point, thanks for the explanation.

I'll merge this then.

johannes
