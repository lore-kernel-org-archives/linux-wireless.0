Return-Path: <SRS0=699K=WS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BAFC3A5A1
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 20:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76ADC21848
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Aug 2019 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfHVUIS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:08:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40936 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfHVUIS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Aug 2019 16:08:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0tNY-00089b-2B; Thu, 22 Aug 2019 22:08:16 +0200
Message-ID: <0452a0cbb36bcffa8371a58dfd931864c1f79eef.camel@sipsolutions.net>
Subject: Re: Implementing Mikrotik IE
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Josef Miegl <josef@miegl.cz>
Cc:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Thu, 22 Aug 2019 22:08:13 +0200
In-Reply-To: <5ee160209eb1f9e70f6224c393389266280d7d80.camel@sipsolutions.net> (sfid-20190822_090033_537095_4B41631C)
References: <20190815152844.k5mmddvbwrohkzr6@pepin-laptop.localdomain>
         <3a079683-6f57-3b42-f909-90c46e14f14f@newmedia-net.de>
         <20190816111044.4ntizgmpa3twbzcg@pepin-laptop.localdomain>
         <e8129acb-fc32-c85c-b504-ab8777a3f1a3@newmedia-net.de>
         <20190816113818.ohktykc4fyetzyvq@pepin-laptop.localdomain>
         <9985fddfb059640f36665efc9c1ef2dc0bdb7662.camel@sipsolutions.net>
         <20190819113706.ujsz67sxcwt2ulmt@pepin-laptop.localdomain>
         <b3b7a99971f1512b4cd9c72920b699c252c1ae83.camel@sipsolutions.net>
         <A3C14EA9-BA2D-4745-BBB9-E10028B6DE13@miegl.cz>
         <6efb9b56c77cd9ea945f89c3371b49c301dc2b4e.camel@sipsolutions.net>
         <58A25955-2A17-4DE7-82FB-3B20E00C96EC@miegl.cz>
         <5ee160209eb1f9e70f6224c393389266280d7d80.camel@sipsolutions.net>
         (sfid-20190822_090033_537095_4B41631C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-08-22 at 09:00 +0200, Johannes Berg wrote:
> 
> Perhaps it expects the 4-way-HS to already be in 4-addr frame format, or
> something else special in the 4-way-HS if you have WDS?

I think this is actually the right guess.

The working capture you sent me has the EAPOL 2/4 in a 4-addr frame:

ToDS=1, FromDS=1
A1/RA = AP
A2/TA = STA
A3/DA = AP
A4/SA = STA

The non-working capture has the EAPOL 2/4 in 3-addr format, as you'd
expect in the Linux 4-addr AP/STA case:

ToDS=1, FromDS=0
A1/RA    = AP
A2/TA,SA = STA
A3/DA    = AP

Since it's basically ignoring the message 2 (it just says "handshake
timed out" later) it's almost certainly expecting *only* the 4-addr
format.

As a hack, you could do

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2623,8 +2623,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
                        memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
                        memcpy(hdr.addr3, sdata->u.mgd.bssid, ETH_ALEN);
                        hdrlen = 24;
-               }  else if (sdata->u.mgd.use_4addr &&
-                           cpu_to_be16(ethertype) != sdata->control_port_protocol) {
+               }  else if (sdata->u.mgd.use_4addr) {
                        fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
                                          IEEE80211_FCTL_TODS);
                        /* RA TA DA SA */


in mac80211, then it should send 4-addr frames even for EAPOL.

johannes

