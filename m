Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4A0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 10:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A5B920700
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 10:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732857AbfC0K01 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfC0K01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 06:26:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA3543088A70;
        Wed, 27 Mar 2019 10:26:26 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2E285BBB7;
        Wed, 27 Mar 2019 10:26:25 +0000 (UTC)
Date:   Wed, 27 Mar 2019 11:26:24 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20190327102623.GA20943@redhat.com>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <20190325143611.sjwwjqtrftxntwyk@penguin>
 <20190326075414.GA8598@redhat.com>
 <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 27 Mar 2019 10:26:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 27, 2019 at 04:59:44AM +0000, Tony Chuang wrote:
> > > I also tested on RTL8822CE we generously got from Tony. I replaced wifi
> > > card on my laptop by the 8822CE device. I have warning on resume from
> > > suspend (see below, it could be mac80211 issue though). But network
> > > connection was established after the warning and in general device
> > > works stable for 2 days now.
> > >
> > > Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > >
> > > [16158.826873] rtw_pci 0000:02:00.0: start vif 00:e0:4c:09:94:0f on port 0
> > > [16158.827693] ------------[ cut here ]------------
> > > [16158.827694] wlan0: invalid CW_min/CW_max: 0/0
> > 
> > I didn't test system suspend/resume with this driver yet (oops), but
> > FWIW I've seen reports of this warning on every other mac80211 driver
> > I've supported. I don't think we've ever totally resolved them and I
> > haven't looked closely into the reason for the WARNING.

It looks as mac80211 issue for me as well.

> And we haven't submit patches related to suspend yet.
> Like something in CONFIG_PM.
> Should be added later.

Suspend/resume works for me anyway :-)

Stanislaw
