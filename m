Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232FBECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06AE2150F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B06AE2150F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbeJQVga (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:36:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46080 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeJQVga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 17:36:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCm42-0002Qg-Sh; Wed, 17 Oct 2018 15:40:43 +0200
Message-ID: <4645ed5a5edaafcca94b1483212f9a70f45cf36f.camel@sipsolutions.net>
Subject: Re: [LKP] f77477b162: hwsim.ap_open_multicast_to_unicast.fail
From:   Johannes Berg <johannes@sipsolutions.net>
To:     kernel test robot <rong.a.chen@intel.com>,
        Enrique Giraldo <hgiraldos@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Enrique Giraldo <enrique.giraldo@galgus.net>, lkp@01.org
Date:   Wed, 17 Oct 2018 15:40:29 +0200
In-Reply-To: <20181017055345.GD16117@shao2-debian> (sfid-20181017_075406_056632_411BCB4D)
References: <20181017055345.GD16117@shao2-debian>
         (sfid-20181017_075406_056632_411BCB4D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-17 at 13:53 +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: f77477b1624c0ac20c0c85c8b529da48686ab54d ("[PATCH] New functionality for aborting ongoing CAC.")
> url: https://github.com/0day-ci/linux/commits/Enrique-Giraldo/New-functionality-for-aborting-ongoing-CAC/20180925-181417
> base: https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git master
> 
> in testcase: hwsim
> with following parameters:
> 
> 	group: hwsim-01

Yeah, this patch completely broke the nl80211 API :-)

johannes

