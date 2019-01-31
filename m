Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA97EC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8500C218DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 11:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfAaLz1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:55:27 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbfAaLz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 06:55:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpAw9-00065W-DX; Thu, 31 Jan 2019 12:55:17 +0100
Message-ID: <e1e062f20e61e61e1428802436248782be08ea7d.camel@sipsolutions.net>
Subject: Re: [PATCH v4 09/13] rtw88: chip files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Thu, 31 Jan 2019 12:55:15 +0100
In-Reply-To: <87ef8tjb7n.fsf@kamboji.qca.qualcomm.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
         <1548820940-15237-10-git-send-email-yhchuang@realtek.com>
         <20190130194453.GA156750@google.com>
         <F7CD281DE3E379468C6D07993EA72F84D179ABC2@RTITMBSVM04.realtek.com.tw>
         <87ef8tjb7n.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-31 at 13:52 +0200, Kalle Valo wrote:
> Tony Chuang <yhchuang@realtek.com> writes:
> 
> > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > 
> > > > +static inline void
> > > > +rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
> > > > +{
> > > > +	BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);
> > > 
> > > This seems to be a non-traditional use of BUILD_BUG_ON(). Normally, I
> > > see this used for stuff that's guaranteed to be known at compile time --
> > > structure offsets, constants, etc. This is usually (always?) a constant,
> > > but it passes through a function parameter, so I'm not sure if that's
> > > really guaranteed.
> > > 
> > > Anyway...this is failing confusingly for me when I try to build:
> > > 
> > > drivers/net/wireless/realtek/rtw88/rtw8822b.c: In function
> > > ‘rtw_write32s_mask’:
> > > drivers/net/wireless/realtek/rtw88/rtw8822b.c:230:176: error: call to
> > > ‘__compiletime_assert_230’ declared with attribute error: BUILD_BUG_ON
> > > failed: addr < 0xC00 || addr >= 0xD00
> > >   BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);
> > > 
> > > ^
> > > 
> > > I tried to pinpoint which call yielded this, and I think once I deleted
> > > enough calls to rtw_write32s_mask() it came down to this one:
> > > 
> > >         rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x3f,
> > > 0x0);
> > > 
> > > which doesn't really make sense, as that's a value of 0xcbc.
> > > 
> > > What I really think it comes down to is that you can't guarantee
> > > rtw_write32s_mask() will get inlined, and so BUILD_BUG_ON() may not know
> > > what to do with it.
> > 
> > Yeah, you're right. I think we should turn it into macro.
> 
> Does this really need to be a build time check? Like Brian said, this is
> not really common use of BUILD_BUG_ON(). I would just change it to
> WARN_ON_ONCE() or a ratelimited warning message so that we don't to have
> an ugly macro.

Well, it *is* strictly stronger as a build-time check, so that makes
sense?

I'd probably still suggest doing something like this:

static inline void _rtw_write32s_mask(...)
{
  ... as before w/o BUILD_BUG_ON ...
}
#define rtw_write32s_mask(bla, bla) do { \
   BUILD_BUG_ON(...); \
   _rtw_write32s_mask(...); \
} while (0)

so you also get the type checks etc. from having actual function args.

johannes

