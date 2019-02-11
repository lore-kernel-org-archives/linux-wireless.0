Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B8FC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 05:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9982B2146F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 05:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfBKFmD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:42:03 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54899 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKFmD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 00:42:03 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B5fa8k013007, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B5fa8k013007
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 13:41:36 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 11 Feb
 2019 13:41:35 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 08/13] rtw88: debug files
Thread-Topic: [PATCH v4 08/13] rtw88: debug files
Thread-Index: AQHUuFC0DSsi7hsaw0mRa3Yo1It/TaXK18wAgA9M1PA=
Date:   Mon, 11 Feb 2019 05:41:34 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2A9D@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-9-git-send-email-yhchuang@realtek.com>
 <20190201194938.GA98048@google.com>
In-Reply-To: <20190201194938.GA98048@google.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Brian Norris [mailto:briannorris@chromium.org]
> 
> Hi,
> 
> On Wed, Jan 30, 2019 at 12:02:15PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > debug files for Realtek 802.11ac wireless network chips
> >
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/debug.c | 631
> +++++++++++++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/debug.h |  35 ++
> >  2 files changed, 666 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/debug.h
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/debug.c
> b/drivers/net/wireless/realtek/rtw88/debug.c
> > new file mode 100644
> > index 0000000..d0cb9d3
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> > @@ -0,0 +1,631 @@
> 
> ...
> 
> > +#ifdef CONFIG_RTW88_DEBUG
> > +
> > +void __rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...)
> > +{
> > +	struct va_format vaf = {
> > +		.fmt = fmt,
> > +	};
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +	vaf.va = &args;
> > +
> > +	if (net_ratelimit())
> > +		dev_dbg(rtwdev->dev, "%pV", &vaf);
> 
> I understand some questions came up about this dbg() interface
> previously, without the most constructive result, but...
> 
> ...I do find one particular aspect of this interface a little weird: it
> has its own separate Kconfig flag, and yet it's still implicitly
> dependent on CONFIG_DYNAMIC_DEBUG. Note how dev_dbg() gets completely
> stubbed out if !defined(CONFIG_DYNAMIC_DEBUG) && !defined(DEBUG).
> 
> I think some other similar loggers end up just using
> dev_printk(KERN_DEBUG, ...) for this piece of the equation, so that if
> somebody has bothered to enable CONFIG_RTW88_DEBUG, they can be sure
> their log messages are at least compiled in.
> 
> But then, other drivers that have used dev_printk() *also* have dynamic
> methods to enable/disable their dbg-level messages (e.g., with a 'mask'
> module parameter, for classifying different types of messages). That
> also gives us the option of compiling in the messages while leaving them
> disabled for printing by default. IOW, they basically implement a
> categorized version of CONFIG_DYNAMIC_DEBUG.
> 
> (Also note: my systems generally have DYNAMIC_DEBUG disabled, but we
> *do* like to have a few driver-specific debug options enabled for WiFi,
> so we can debug problems in the field via runtime enable/disable.)
> 
> Altogether, I think this means you should either:
> 
>  (a) alias RTW88_DEBUG with DYNAMIC_DEBUG (e.g., RTW88_DEBUG selects
> or
>      depends on DYNAMIC_DEBUG?) or, remove your own special Kconfig
>      entirely; or
>  (b) implement runtime controls to enable/disable your dbg() messages,
>      and do not depend on DYNAMIC_DEBUG
> 
> I kinda lean toward (b), since that's how many other WiFi drivers work,
> and it prevents me from having to enable all of DYNAMIC_DEBUG (although,
> it may be time to reevaluate why Chrome OS has it disabled...probably
> just for mild savings on size). It also gives you the option of
> classifying your debug messages even further.
> 

So I think I can add a debug_mask and change dev_dbg to dev_printk.
And leave rtw_[err|warn|info] unchanged. This way rtw_dbg will no more
depend on DYNAMIC_DEBUG, also better for a wifi driver to select debug
messages we want. Actually as more components added I think it's time to
do it for developers to debug on various scenarios. :)

It will take days for me to change the debug log and resend the patch set.
But I think it's worth that we don't bother to have another patch to fix it.
And I hope it won't have bad impact for reviewers.

Yan-Hsuan

