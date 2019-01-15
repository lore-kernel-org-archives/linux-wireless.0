Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A01C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2293020651
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfAONpx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:45:53 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57244 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbfAONpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:45:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjP2J-0008D2-Dj; Tue, 15 Jan 2019 14:45:47 +0100
Message-ID: <03c1e278fdd880bf7409c0b1c03366178b765cda.camel@sipsolutions.net>
Subject: Re: Tx power for slave devices in ETSI DFS region
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Tue, 15 Jan 2019 14:45:46 +0100
In-Reply-To: <423eaa39-fc06-6a5a-a8fd-5e15d503dff5@quantenna.com> (sfid-20181211_033105_299408_08BD2B1C)
References: <423eaa39-fc06-6a5a-a8fd-5e15d503dff5@quantenna.com>
         (sfid-20181211_033105_299408_08BD2B1C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Igor,

On Tue, 2018-12-11 at 02:30 +0000, Igor Mitsyanko wrote:
> Hello,
> 
> according to ETSI 
> https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/en_301893v020101p.pdf
> section 4.2.3.2.2, table 2
> Note 3 states:
>  >Slave devices without a Radar Interference Detection function shall 
>  >comply with the limits for the frequency range 5 250 MHz to 5 350 MHz.
> 
> And Tx power limits are defined as following:
> 5150 to 5350: 20 dbm
> 5470 to 5725: 27 dbm

> Which means that if STA device can not do radar detection, it must use 
> 20dbm Tx powers on all channels (can not use 27 dbm limit).
> 
> 
> Looking at regdb 
> https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/tree/db.txt, 
> power limit for frequency range 5470 to 5725 is defined at 27 dbm.

I guess somebody misinterpreted the spec, or some countries are less
strict?

> Question is: does wireless core assumes that each device can do radar 
> detection in slave modes (eg acting as a STA) and it is enabled by 
> default? I couldn't find any logic in kernel which would limit 27 dbm 
> power to 20 for STA devices.

No, we shouldn't assume that it can do radar detection by itself ...

I guess we should have some code? Or just fix the regdb?

johannes


