Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21A0C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 09:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB4B2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 09:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AB4B2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbeKUTo5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 14:44:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39772 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeKUTo4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 14:44:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gPOXS-0000U5-Rp; Wed, 21 Nov 2018 10:11:15 +0100
Message-ID: <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim: multiple antennas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 21 Nov 2018 10:11:13 +0100
In-Reply-To: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com> (sfid-20181120_203341_461821_AD8C0481)
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
         (sfid-20181120_203341_461821_AD8C0481)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-11-20 at 16:33 -0300, Ramon Fontes wrote:
> Would be possible to simulate (or even add support to) multiple
> antennas? I was trying to extend wmediumd to 802.11n according the
> rates provided by http://mcsindex.com/, but the maximum rate I get is
> ~33Mbps, even if I set the MCS index to 15. Given the result, I
> thought that it could be related to the number of antennas. Is my
> assumption correct?

I'm not sure what you mean by "the maximum rate I get is ~33Mbps".

Are you trying to actually _measure_ it? Then, on a decent platform, you
should probably get many *gigabits*.

Or are you trying to look at the rate in "iw station dump" or in
radiotap? Then you should see higher rates since hwsim is configured to
pretend to have 4 spatial streams (IIRC)

johannes

