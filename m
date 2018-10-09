Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694F6C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39BB62087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39BB62087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbeJIPLR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 11:11:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44992 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIPLQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 11:11:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9mrf-0007I4-V4; Tue, 09 Oct 2018 09:55:36 +0200
Message-ID: <1539071724.3687.87.camel@sipsolutions.net>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Tue, 09 Oct 2018 09:55:24 +0200
In-Reply-To: <5BBC2D46.1060903@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2) <1539010630.3687.86.camel@sipsolutions.net>
         <5BBC2D46.1060903@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 04:23 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> > I don't know what you need the shadow stuff for, but you should remove
> > it anyway, and use the cfg80211 functionality instead. If not
> > sufficient, propose patches to improve it?
> 
> The point behind using a shadow buffer was to keep the scan results
> consistent between consecutive scans, and smooth out the cases where
> an AP isn't found momentarily during scanning.
> In this implementation, APs found during scanning are added to the
> shadow list, and removed if not found again for a period of time.
> 
> I'm not much in favour of this implementation neither since it
> complicates the driver's logic, but it was serving the purpose.

You really should remove it - cfg80211 *and* wpa_s already do this if
required.

johannes
