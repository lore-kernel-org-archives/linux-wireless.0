Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6602C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 788A720834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 15:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 788A720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbeLCPHJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:07:09 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38370 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeLCPHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 10:07:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gTpoN-0001su-V1; Mon, 03 Dec 2018 16:07:04 +0100
Message-ID: <1b04a2b4c823a608bc26849964ec970ae480ee13.camel@sipsolutions.net>
Subject: Re: Issue with STBC capability and forcing radio to 1x1 mode.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Mon, 03 Dec 2018 16:07:02 +0100
In-Reply-To: <2827d468-5bba-61ed-66db-89b670a5330b@candelatech.com> (sfid-20181128_231326_010040_35D01B3D)
References: <2827d468-5bba-61ed-66db-89b670a5330b@candelatech.com>
         (sfid-20181128_231326_010040_35D01B3D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-11-28 at 14:13 -0800, Ben Greear wrote:
> Hello,
> 
> I notice some weird things while debugging an issue on a 4.16+ kernel with ath10k
> radio.
> 
> It seems that the 'iw phy info' does not remove the TX-STBC info
> when changing the antenna mask _until_ some vdev is brought up.
> 
> This makes it difficult to properly create hostapd config files.
> 
That's not anything iw can do, must be the driver.

johannes

