Return-Path: <SRS0=7/HX=4V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B85C3F2CD
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 12:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 673C721741
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 12:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387879AbgCDMQ0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Mar 2020 07:16:26 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51648 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgCDMQ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Mar 2020 07:16:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9Swp-00Fefv-23; Wed, 04 Mar 2020 13:16:23 +0100
Message-ID: <5c542c4ce1b5373e8fe280913b74926f4d36e2d1.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: fix tx_control_port trace point
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 04 Mar 2020 13:16:22 +0100
In-Reply-To: <20200304114952.1827-1-markus.theil@tu-ilmenau.de>
References: <20200304114952.1827-1-markus.theil@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-03-04 at 12:49 +0100, Markus Theil wrote:
> Endianess conversion should not happen when writing out the string,
> instead convert proto endiannes when creating the trace point data,
> like its already done for control port rx.
> 
> Without this patch, trace looks like:
> <...>-53819 [000] 12957.654875: rdev_tx_control_port: [FAILED TO PARSE]
>   wiphy_name=phy0 name=wlan0 ifindex=3 dest=ARRAY[dc, 7b, 94, a5, bb, 3e]
>   proto=36488 unencrypted=1
> 
> After applying this patch:
> wpa_supplicant-553   [001]   121.211264: rdev_tx_control_port: phy0,
>   netdev:wlan0(3), dc:7b:94:a5:bb:3e, proto: 0x888e, unencrypted: true

This is from trace-cmd? That just means it doesn't know about the endian
conversion, but I don't really see any reason to change this - big
endian is a perfectly valid format for trace points?

Maybe teach trace-cmd to understand it? We already did that for
__le16_to_cpu().

johannes

