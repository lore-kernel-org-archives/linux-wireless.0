Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1C0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CA92087C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="RKq+xbMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfBZLK0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:10:26 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:36007 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfBZLK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 06:10:26 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2019 06:10:25 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1551179424;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=NTJ1/GTBQLroPgv3yXOXY9ou18+4xRGJwgU9nlQMKtA=;
        b=RKq+xbMv9ZLIOdDq1zaVbPdiN1nluvigqbwrBpZCZXoXXoM1RTnEqpRGFFQ+dAE3Do
        s6V0AP65Tjb60o9/Ja16YiOm8CKWU/RKCCEWdx8KCJYMMzYeFnLPF/rZ9br4FgUjZGHG
        NZc8UANm1lrApNL+buLzQPB1FbyTTeOdPzcyOWkVEHG5FvL0Y5YIDfn58gk5BMBOVM4N
        oPF2kYex0We1INC60DCq6xwHSh1e4pVVasGW3aCfnqxdXwqt5n7Me30rYEHqgBUBd7nU
        BhzFS1/qea9FrZFqJPFCD6/5nF4D3QofWjjYNT/A4nyGNwQgswsnukBAe6r1+uNL3JH9
        bghQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3jXdVqE32oRVrGn+2w7fg=="
X-RZG-CLASS-ID: mo00
Received: from [10.180.89.44]
        by smtp.strato.de (RZmta 44.13 AUTH)
        with ESMTPSA id e06351v1QB4D5KF
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 26 Feb 2019 12:04:13 +0100 (CET)
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of tx_status
 frames
To:     Julius Niedworok <julius.n@gmx.net>, linux-wireless@vger.kernel.org
Cc:     ga58taw@mytum.de, david@redhat.com, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190226094104.35192-1-julius.n@gmx.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
Date:   Tue, 26 Feb 2019 12:04:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190226094104.35192-1-julius.n@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Julius,

On 26.02.19 10:40, Julius Niedworok wrote:

> In order to force delivery of TX status frames for research and debugging
> purposes, implement the IFF_ECHO flag for ieee80211 devices. When this flag
> is set for a specific interface, IEEE80211_TX_CTL_REQ_TX_STATUS is enabled
> in all packets sent from that interface. IFF_ECHO can be set via
> /sys/class/net/<dev>/flags. The default is disabled.

(..)

> +	/*
> +	 *	Force TX status frames on ieee80211 devices.
> +	 *	Since IFF_ECHO is used by CAN devices for a different
> +	 *	purpose, we must check dev->ieee80211_ptr.
> +	 */

The reason for IFF_ECHO was, that the data frame which is sent onto the 
wire (by one application) is not visible to all the other applications 
on the same (local) host. Therefore a successful transmission on the 
wire triggers the 'echo' of the sent content into the local host.

So what are you getting back after you enabled IFF_ECHO on your mac80211 
device?

Is it just a 'status' about a sent packet, or is it the packet ('full 
content') itself?

Regards,
Oliver

