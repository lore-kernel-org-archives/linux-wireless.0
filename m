Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FB3C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 20:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3907820824
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 20:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3907820824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbeJ3FCV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 01:02:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47126 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729599AbeJ3FCS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 01:02:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHDtL-0003K2-In; Mon, 29 Oct 2018 21:12:03 +0100
Message-ID: <8d6f1b65622f3602ac37c8ae6256930226520c0a.camel@sipsolutions.net>
Subject: Re: [PATCH 12/19] wilc: add wilc_wfi_cfgoperations.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Adham.Abozaeid@microchip.com, Ajay.Kathat@microchip.com,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        Ganesh.Krishna@microchip.com, Aditya.Shankar@microchip.com,
        Venkateswara.Kaja@microchip.com, Claudiu.Beznea@microchip.com
Date:   Mon, 29 Oct 2018 21:11:42 +0100
In-Reply-To: <5BCA50F7.3080809@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-13-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_015616_502D99E2) <1539010630.3687.86.camel@sipsolutions.net>
         <5BBC2D46.1060903@microchip.com>
         <1539071724.3687.87.camel@sipsolutions.net>
         <5BBCE23B.6050003@microchip.com> <5BCA50F7.3080809@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry for the late reply.

On Fri, 2018-10-19 at 21:47 +0000, Adham.Abozaeid@microchip.com wrote:
> 
> Johannes, shadow buffer has 2 more usage that I missed in my first email:
> 1- It keeps a copy of scan results to be able to auto-select from if
> the cfg80211 didn't supply a specific bssid in cfg's connect request
> (struct cfg80211_connect_params).
> In this case the driver will select a network that matches the ssid,
> while having the highest rssi.

You should be able to find this from cfg80211's BSS list as well.

If we lack some API in this area, which is possible, then we can add it.

> 2- It keeps network parameters that the device will need to connect
> to a network, since the device doesn't keep the scan results
> internally.
> These parameters are stored in struct join_bss_param, and passed to
> the device  when a connect request is received.
> Some of these parameters can be extracted from cfg's
> cfg80211_connect_params (like cap_info.. etc), but others (like bssid,
> beacon period.. etc) are still required.

Again though, you should be able to extract these from struct
cfg80211_bss, I'd argue?

johannes

