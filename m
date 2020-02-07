Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BC1C352A2
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 10:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A48206CC
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 10:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgBGKnq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:43:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42890 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGKnp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Feb 2020 05:43:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j016s-0080J4-P3; Fri, 07 Feb 2020 11:43:42 +0100
Message-ID: <bec978c2c7d1cbd9013a7db4cf40015929892150.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix regulatory data is reset in case all phys
 have disconnected
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Orr Mazor <orr.mazor@tandemg.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Fri, 07 Feb 2020 11:43:41 +0100
In-Reply-To: <AM0PR02MB3620B9D7A4F68BA601B0445FEF360@AM0PR02MB3620.eurprd02.prod.outlook.com>
References: <20200115150123.7612-1-Orr.Mazor@tandemg.com>
         <CAKR_QVJkVSCuzZWgOxxmkffTYG3pgX4ZX_vvw-6Th5=tvs7ovg@mail.gmail.com>
         <AM0PR02MB3620B9D7A4F68BA601B0445FEF360@AM0PR02MB3620.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-01-16 at 12:23 +0000, Orr Mazor wrote:
> > 
> I have tested this on mac80211_hwsim and on a intel proprietary device.
> The issue (before the patch) is seen in both, and the patch solves it in both.

However, it breaks hwsim tests, e.g. this one:

START he160b 1/1
wlan0: Country code not reset back to 00: is 98
Country code remains set - expect following test cases to fail
FAIL he160b 68.974926 2020-02-07 10:49:51.312663
failed tests: he160b

So maybe it wasn't quite right somehow?

johannes

