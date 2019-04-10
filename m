Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74BFC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E22B20850
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfDJH2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:28:35 -0400
Received: from nbd.name ([46.4.11.11]:55180 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbfDJH2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 03:28:34 -0400
Received: from p548c87d0.dip0.t-ipconnect.de ([84.140.135.208] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hE7ep-0007gR-0e; Wed, 10 Apr 2019 09:28:31 +0200
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading
 support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190401131416.22646-1-john@phrozen.org>
 <20190401131416.22646-2-john@phrozen.org> <87k1gcpwgy.fsf@toke.dk>
From:   John Crispin <john@phrozen.org>
Message-ID: <46dfe65c-3bbf-7923-d358-9acec030f572@phrozen.org>
Date:   Wed, 10 Apr 2019 09:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87k1gcpwgy.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 02/04/2019 11:50, Toke Høiland-Jørgensen wrote:
> ieee80211_queue_skb() calls ieee80211_get_txq() which treats skb->data
> like it contains an 802.11 header. That is probably not the intention
> here, is it?
>
> I guess we could augment the TXQ stuctures to also handle 802.3 frames
> (and introduce ieee80211_queue_skb_8023())? Or would it be better to
> have a qdisc on 802.3-mode interfaces and push packets back to that? I
> guess we'd still benefit from per-station queueing of packets even if
> they are Ethernet frames, which would mean amending the TXQs would be
> better?
>
> -Toke

Hi Toke

This patch guards the usage of the hdr pointer. hdr is only used for non 
data frames which are not relevant when doing encap mode. The code will 
then drop into the same path as for 80211 encapsulated frames. IMHO the 
patch is correct and we do not need an additional 
ieee80211_queue_skb_8023()  to benefit from per station TXQs. Let me 
know if i missed something.

     John


