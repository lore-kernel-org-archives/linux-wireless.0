Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDD5ECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2223E213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2223E213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbeJJCdE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:33:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58270 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeJJCdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 22:33:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9xSl-0001i0-MC; Tue, 09 Oct 2018 21:14:35 +0200
Message-ID: <1539112463.3687.131.camel@sipsolutions.net>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Tue, 09 Oct 2018 21:14:23 +0200
In-Reply-To: <5BBCF51A.2060806@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
         <1539008417.3687.57.camel@sipsolutions.net>
         <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
         <1539081379.3687.112.camel@sipsolutions.net>
         <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
         <1539085569.3687.115.camel@sipsolutions.net>
         <092b38f4-8153-9abd-890a-a42454f22154@microchip.com>
         <5BBCF51A.2060806@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 18:36 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> Johannes, is the cfg80211_scan_request.ssid used for something else
> other than specifying the hidden networks that the controller should
> scan for?

Ahh, now I understand where you're coming from.

Well, it's the SSID to include in the probe request(s), the most common
thing there is the 0-length wildcard, of course.

So while it may be required for hidden networks, it's not strictly
related to that.

johannes
