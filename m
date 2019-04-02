Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20F1C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 13:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 760F820883
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 13:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfDBN2Q convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:28:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40795 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDBN2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 09:28:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id h22so11653371edw.7
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 06:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WOTpC/2mKaV/KWBEoqcmUFsKiYYZn8rv7iMiDs1uUws=;
        b=oxSvNDU63cmGzUroW5hMPUj24YifaL6BMYihx5HojnTc5sNh9BnfduH9T0ED2fH95h
         /owqe98I8fTyjQKk9TkUp0hQD7/BJ5pfFlCtaTN3r4pcZcEeNYQaB/krB0JZ5xZ64bs1
         bG7ebzYLCm+/MGfvUrIT+eFOxz/wqnoUhuJVT+cmy7FX12H1oww3YssLLt2L8CfJ3Tps
         Hm3qWLkeUI1yfNDE6bn0djTDZxkmnGw0coHUQbtU+PDOLAcQ67yx89hM4de03yhLwNMk
         PBrhOxaJzoRt9oJPK40VNyBNUTIzghdjYHYxjHGpwSnYgOpIlJYPiQO4dz4hParMk+MV
         ifRg==
X-Gm-Message-State: APjAAAUpWkCOfO1FpGJL/Md+9Nl8xCVGQJk3KQJlzfQapvDQmLPBuOuz
        ALlnOZjQ8fQL1JcbC6jd67DNUg==
X-Google-Smtp-Source: APXvYqw/9GZ2ivY1uCrrYPoYfP9ZwY6xY0BBLaYxZXy0L/FcbwIB3uwVWXVX7uAq153o0YnCu+aGoA==
X-Received: by 2002:a50:a725:: with SMTP id h34mr37059859edc.201.1554211694874;
        Tue, 02 Apr 2019 06:28:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y12sm10424ejo.85.2019.04.02.06.28.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Apr 2019 06:28:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B9EEC18200F; Tue,  2 Apr 2019 15:28:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading support
In-Reply-To: <5647fa751aed450f09312c35f8d5becd47e26b66.camel@sipsolutions.net>
References: <20190401131416.22646-1-john@phrozen.org> <20190401131416.22646-2-john@phrozen.org> <87k1gcpwgy.fsf@toke.dk> <5647fa751aed450f09312c35f8d5becd47e26b66.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 02 Apr 2019 15:28:13 +0200
Message-ID: <878swspmdu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-04-02 at 11:50 +0200, Toke Høiland-Jørgensen wrote:
>
> [snip, you really should try that sometimes ;-)]
>
>> ieee80211_queue_skb() calls ieee80211_get_txq() which treats skb-
>> datalike it contains an 802.11 header. That is probably not the
>> intention here, is it?
>
> Indeed, that makes no sense.
>
>> I guess we could augment the TXQ stuctures to also handle 802.3 frames
>> (and introduce ieee80211_queue_skb_8023())? Or would it be better to
>> have a qdisc on 802.3-mode interfaces and push packets back to that? I
>> guess we'd still benefit from per-station queueing of packets even if
>> they are Ethernet frames, which would mean amending the TXQs would be
>> better?
>
> TXQs would be better, yes. We should do that.

Cool. Glad that we agree ;)

-Toke
