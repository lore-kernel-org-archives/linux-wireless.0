Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AD4C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE5E20883
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfDBMoq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 08:44:46 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38604 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbfDBMop (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 08:44:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBImO-0006K4-Al; Tue, 02 Apr 2019 14:44:40 +0200
Message-ID: <5647fa751aed450f09312c35f8d5becd47e26b66.camel@sipsolutions.net>
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date:   Tue, 02 Apr 2019 14:44:37 +0200
In-Reply-To: <87k1gcpwgy.fsf@toke.dk> (sfid-20190402_115023_938695_D3135246)
References: <20190401131416.22646-1-john@phrozen.org>
         <20190401131416.22646-2-john@phrozen.org> <87k1gcpwgy.fsf@toke.dk>
         (sfid-20190402_115023_938695_D3135246)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-02 at 11:50 +0200, Toke Høiland-Jørgensen wrote:

[snip, you really should try that sometimes ;-)]

> ieee80211_queue_skb() calls ieee80211_get_txq() which treats skb-
> datalike it contains an 802.11 header. That is probably not the
> intention here, is it?

Indeed, that makes no sense.

> I guess we could augment the TXQ stuctures to also handle 802.3 frames
> (and introduce ieee80211_queue_skb_8023())? Or would it be better to
> have a qdisc on 802.3-mode interfaces and push packets back to that? I
> guess we'd still benefit from per-station queueing of packets even if
> they are Ethernet frames, which would mean amending the TXQs would be
> better?

TXQs would be better, yes. We should do that.

johannes

