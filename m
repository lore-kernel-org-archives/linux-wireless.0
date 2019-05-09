Return-Path: <SRS0=9IVB=TJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E4AC04AB1
	for <linux-wireless@archiver.kernel.org>; Thu,  9 May 2019 09:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E71DC21479
	for <linux-wireless@archiver.kernel.org>; Thu,  9 May 2019 09:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfEIJhK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 9 May 2019 05:37:10 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:55121 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbfEIJhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 May 2019 05:37:10 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2019 05:37:09 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id B5CB218022F2A
        for <linux-wireless@vger.kernel.org>; Thu,  9 May 2019 09:29:39 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id CFD69100E86CA;
        Thu,  9 May 2019 09:29:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: skate64_198a4048ff50b
X-Filterd-Recvd-Size: 2238
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu,  9 May 2019 09:29:35 +0000 (UTC)
Message-ID: <1f6fbb9fdcea4a39ff11cd977a5ce46babe34454.camel@perches.com>
Subject: Re: [RFC PATCH 1/2] rtl8xxxu: Add rate adaptive related data
From:   Joe Perches <joe@perches.com>
To:     Daniel Drake <drake@endlessm.com>, Chris Chiu <chiu@endlessm.com>
Cc:     jes.sorensen@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date:   Thu, 09 May 2019 02:29:34 -0700
In-Reply-To: <CAD8Lp45WmPz2c+OnszFyaRL=veF0avEffwv3muwXNoeLcE0fhw@mail.gmail.com>
References: <20190503072146.49999-1-chiu@endlessm.com>
         <20190503072146.49999-2-chiu@endlessm.com>
         <CAD8Lp45WmPz2c+OnszFyaRL=veF0avEffwv3muwXNoeLcE0fhw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-05-09 at 16:11 +0800, Daniel Drake wrote:
> On Fri, May 3, 2019 at 3:22 PM Chris Chiu <chiu@endlessm.com> wrote:
> > Add wireless mode, signal strength level, and rate table index
> > to tell the firmware that we need to adjust the tx rate bitmap
> > accordingly.
[]
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
[]
> > +/*mlme related.*/
> > +enum wireless_mode {
> > +       WIRELESS_MODE_UNKNOWN = 0,
> > +       //Sub-Element
> 
> Run these patches through checkpatch.pl, it'll have some suggestions
> to bring the coding style in line, for example not using // style
> comments.

just fyi:

checkpatch ignores // comments since 2016
(new in 2019: unless you add --ignore=c99_comment_tolerance)

These are the relevant checkpatch commits:

In 2016, commit dadf680de3c2 ("checkpatch: allow c99 style // comments")
In 2019, commit 98005e8c743f ("checkpatch: allow reporting C99 style comments")




