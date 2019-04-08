Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED7DC10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B662087F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfDHM0w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:26:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54084 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfDHM0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:26:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDTMR-0006F8-0s; Mon, 08 Apr 2019 14:26:51 +0200
Message-ID: <ad4fbfcb67afcb63c34711d14459b2a183831e38.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: optimize skb resizing
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 14:26:49 +0200
In-Reply-To: <20190317181859.71841-1-nbd@nbd.name>
References: <20190317181859.71841-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-03-17 at 19:18 +0100, Felix Fietkau wrote:
> When forwarding unicast packets from ethernet to batman-adv over 802.11s
> (with forwarding disabled), the typical required headroom to transmit
> encrypted packets on mt76 is 32 (802.11) + 6 (802.11s) + 8 (CCMP) +
> 2 (padding) + 6 (LLC) + 18 (batman-adv) - 14 (old ethernet header) = 58 bytes.
> 
> On systems where NET_SKB_PAD is 64 this leads to a call to pskb_expand_head
> for every packet, since mac80211 also tries to allocate 16 bytes status
> headroom for radiotap headers.
> 
> This patch fixes these unnecessary reallocations by only requiring the extra
> status headroom in ieee80211_tx_monitor()
> If however a reallocation happens before that call, the status headroom gets
> added there as well, in order to avoid double reallocation.
> 
> The patch also cleans up the code by moving the headroom calculation to
> ieee80211_skb_resize.

This doesn't apply, not really sure why.

johannes

