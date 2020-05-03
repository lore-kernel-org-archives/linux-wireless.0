Return-Path: <SRS0=doFA=6R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9886DC28CBC
	for <linux-wireless@archiver.kernel.org>; Sun,  3 May 2020 23:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A39206EB
	for <linux-wireless@archiver.kernel.org>; Sun,  3 May 2020 23:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgECX35 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 May 2020 19:29:57 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:49402 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgECX35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 May 2020 19:29:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 2690716921;
        Sun,  3 May 2020 23:29:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: brick38_5682053cb3621
X-Filterd-Recvd-Size: 2157
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun,  3 May 2020 23:29:54 +0000 (UTC)
Message-ID: <d3e07dfd0efe21192d172b2e4e7d4a489a4fcc62.camel@perches.com>
Subject: Re: [PATCH v2] staging: wilc1000: Increase the size of wid_list
 array
From:   Joe Perches <joe@perches.com>
To:     Ajay.Kathat@microchip.com, oscar.carter@gmx.com,
        adham.abozaeid@microchip.com
Cc:     gregkh@linuxfoundation.org, rachel.kim@atmel.com,
        johnny.kim@atmel.com, chris.park@atmel.com, dean.lee@atmel.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 03 May 2020 16:29:53 -0700
In-Reply-To: <d75b7f64-0ba0-65e9-ea4c-cc87b3a51a10@microchip.com>
References: <20200503075145.4563-1-oscar.carter@gmx.com>
         <d75b7f64-0ba0-65e9-ea4c-cc87b3a51a10@microchip.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-05-03 at 14:52 +0000, Ajay.Kathat@microchip.com wrote:
> On 03/05/20 1:21 pm, Oscar Carter wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Increase by one the size of wid_list array as index variable can reach a
> > value of 5. If this happens, an out-of-bounds access is performed.
> > 
> > Addresses-Coverity-ID: 1451981 ("Out-of-bounds access")
> > Fixes: f5a3cb90b802d ("staging: wilc1000: add passive scan support")
> > Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
[]
> > diff --git a/drivers/staging/wilc1000/hif.c b/drivers/staging/wilc1000/hif.c
[]
> > @@ -151,7 +151,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
> >               void *user_arg, struct cfg80211_scan_request *request)
> >  {
> >         int result = 0;
> > -       struct wid wid_list[5];
> > +       struct wid wid_list[6];

This looks like it should be using a #define instead of
a hard-coded number.

> >         u32 index = 0;
> >         u32 i, scan_timeout;
> >         u8 *buffer;
> > --
> > 2.20.1

