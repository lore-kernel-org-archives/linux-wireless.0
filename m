Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FC7C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 526602085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 20:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 526602085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbeKFFyO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 00:54:14 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58936 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbeKFFyO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 00:54:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gJlYE-0002hN-Po; Mon, 05 Nov 2018 21:32:46 +0100
Message-ID: <34042c1e8020bfb49ab97c9160ab50df044846af.camel@sipsolutions.net>
Subject: Re: [RFC 0/3] cfg80211/nl80211/iw: add basic AMPDU/AMSDU controls
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Jouni Malinen <j@w1.fi>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Date:   Mon, 05 Nov 2018 21:32:23 +0100
In-Reply-To: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
References: <20181105143027.17570-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Here are several RFC patches providing simple high-level controls of AMSDU/AMPDU
> aggregation. The primary purpose of this functionality is an attempt to fill
> missing gaps in nl80211 interface for basic WFA certification tests.

I see you don't implement it this way in the driver, but wouldn't it
make more sense to have this as a per-STA (RA) setting? That's really
the granularity it can be done on, I think?

Arguably even per-RA/TID, though that seems a little excessive?

> We experimented with QCA sigma-dut tool: https://github.com/qca/sigma-dut.
> The purpose was to cover basic HT/VHT WFA STA tests for cfg80211 driver
> controlled by wpa_supplicant  w/o adding any vendor specific commands.
> Multiple WFA test parameters (e.g. STBC, NSS, SGI, LDPC) can be configured
> by overriding HT/VHT capabilities in wpa_supplicant and applying them on
> connect in cfg80211_connect callback. Others (e.g. RTS params) can be
> configured using iw tool or NL80211_CMD_SET_WIPHY directly. These patches
> implement simpe high-level switches for AMSDU/AMPDU aggregation.
> 
> It would be interesting to collect comments/concerns regarding this approach.
> Does it make sense to enhance nl80211 in order to cover all the missing pieces
> required for WFA certification tests ? Or maybe it makes sense to use
> NL80211_TESTMODE subcommands for this kind of testing.

Honestly, I don't really know.

I think other tests, e.g. noack, we used to just have debugfs files for,
and then we got NL80211_CMD_SET_NOACK_MAP (which *is* per TID, btw)

Perhaps if we really don't see any value beyond the testing, keeping it
in debugfs would make sense, until we have more use cases and understand
the granularity we should support?

Clearly this is enough for the testing you refer to, but other use cases
might actually need more fine-grained control (in the future), possibly
down to the RA/TID level?

johannes

