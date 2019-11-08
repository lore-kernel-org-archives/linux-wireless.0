Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC94C5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 10:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70627214DB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 10:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfKHKDT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 05:03:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53466 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbfKHKDT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 05:03:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iT16q-0007P5-ES; Fri, 08 Nov 2019 11:03:16 +0100
Message-ID: <e40e97d46c0f602677e654bd15c5e14f05274852.camel@sipsolutions.net>
Subject: Re: [PATCH v6 1/4] mac80211: Shrink the size of ack_frame_id to
 make room for tx_time_est
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath10k@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kevin Hayes <kevinhayes@google.com>
Date:   Fri, 08 Nov 2019 11:03:15 +0100
In-Reply-To: <157182474063.150713.16132669599100802716.stgit@toke.dk>
References: <157182473951.150713.7978051149956899705.stgit@toke.dk>
         <157182474063.150713.16132669599100802716.stgit@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-10-23 at 11:59 +0200, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> To implement airtime queue limiting, we need to keep a running account of
> the estimated airtime of all skbs queued into the device. Do to this
> correctly, we need to store the airtime estimate into the skb so we can
> decrease the outstanding balance when the skb is freed. This means that the
> time estimate must be stored somewhere that will survive for the lifetime
> of the skb.
> 
> To get this, decrease the size of the ack_frame_id field to 6 bits, and
> lower the size of the ID space accordingly. This leaves 10 bits for use for
> tx_time_est, which is enough to store a maximum of 4096 us, if we shift the
> values so they become units of 4us.
> 

I've applied this as preparation.

johannes

