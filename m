Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F39ECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 11:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 469282086E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 11:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 469282086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbeJRTI1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:08:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33264 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbeJRTI0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 15:08:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gD69j-0005u4-I8; Thu, 18 Oct 2018 13:07:55 +0200
Message-ID: <345677d97346e1f6240105cc709fba00c6dc0c9d.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc:     Sushant Kumar Mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Date:   Thu, 18 Oct 2018 13:07:41 +0200
In-Reply-To: <eba7f8e3-9b51-b82b-fdf6-d440214ec653@broadcom.com> (sfid-20181018_124238_934759_EAD85A6A)
References: <20181018083547.23262-1-johannes@sipsolutions.net>
         <eba7f8e3-9b51-b82b-fdf6-d440214ec653@broadcom.com>
         (sfid-20181018_124238_934759_EAD85A6A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-18 at 12:42 +0200, Arend van Spriel wrote:
> 
> > + *	This callback is also allowed to return the special return value 1,
> > + *	this indicates that hardware scan isn't desirable right now and a
> > + *	software scan should be done instead. A driver wishing to use this
> > + *	capability must ensure its (hardware) scan capabilities aren't
> > + *	advertised as more capable than mac80211's software scan is.
> 
> Not sure what is meant by the last sentence. What does "more capable" 
> mean? What are (or where to find) the mac80211 software scan capabilities?

I was thinking in terms of the scan capabilities exposed to userspace
via nl80211. For example, mac80211 supports max 4 scan SSIDs (though
this is a soft limit, it doesn't really care later), and a maximum probe
request size. That's it though, so it doesn't support things like
NL80211_EXT_FEATURE_LOW_SPAN_SCAN, for example.

johannes

