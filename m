Return-Path: <SRS0=yvfE=2B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA48C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 08:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED5C208C3
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Dec 2019 08:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPTERP/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfLKIxR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:53:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfLKIxR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Dec 2019 03:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576054396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ErN/Wg7v3eiCe0Kx9UO/6mPJH73V49FsTdeJpQaYLfg=;
        b=PPTERP/jZBI9ppL71ptLGVJrSZDALjQL70kgk2W+Uf2DwrX6szRUIGVhtvNA6yb9nQlBH4
        S9mxbydWDCLYQQ8Xg0AlSvnzAwgY3afVzRJIvo75RhB3vE3u1gvS+FeN7AsUYVoNl0hqZM
        Xj8zGk9MHwFbX7s94l5GnfMsFbzq0Hk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-EBAeU8LsMduNDl0rCO-pWg-1; Wed, 11 Dec 2019 03:53:15 -0500
Received: by mail-lj1-f198.google.com with SMTP id f1so4240742ljp.5
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2019 00:53:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pZtJTilsJZlUcalnSJQYHRduUjW4Lu05sEgNkR0v5cc=;
        b=emyNskMezYj1fyj4z2+2ms0EIAXQ47E19rTCsq2381hkAr5vEz2H6IXfqxczbFw+kJ
         kV+ldBnpf9IcifOHLbPY4FpDH4DI2sWSFWiOBwtWdI20C6wZ8F71a13bHY7/JNzzZMog
         RWTmJQ/63VcmYLIx3IgEgRZYPhpzRILJRLjDVMJ7IUwLmJ6yenciHlSn+PxpBczSsZix
         PVevqREgpWbtYZsuDVVx2SVCLWMtWQg2v6mQTdJSZk3KljQ8DZIKy7aOa71Fv0PtJfFK
         mAH3HDd22MVw/hR2qFILr9Z9AeqqC/qLRnAeJ1b4U9pQ74Ns8NDo5v0KY01pu+vqjn6o
         RTsw==
X-Gm-Message-State: APjAAAWK5/7qmX+xhtXmaRtBQq9KKcg4UjNxjGMBcUMYe7u2gQelLbMy
        eU1YaRTL3djRWAX/Py7UIBmPH3zpSG0coY7TwodXZTMQnHrXAzw7VfxUJyey7/Jrirhu3AU2PKs
        xVrIephDte/q143+CJgtBztUwfg0=
X-Received: by 2002:a2e:2201:: with SMTP id i1mr1191566lji.110.1576054392774;
        Wed, 11 Dec 2019 00:53:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzv9/7GEytOxrzOgMa5SPSHN1QlJE2sj9Zc1uAwuE1YS00Wxmllztzk/j/zIsSMKOfS3I0CQ==
X-Received: by 2002:a2e:2201:: with SMTP id i1mr1191555lji.110.1576054392609;
        Wed, 11 Dec 2019 00:53:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v26sm765021lfq.73.2019.12.11.00.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:53:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C5D318033F; Wed, 11 Dec 2019 09:53:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 09:53:10 +0100
Message-ID: <878snjgs5l.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: EBAeU8LsMduNDl0rCO-pWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
>> Hi,
>>=20
>> Since the GRO issue got fixed, iwlwifi has worked fine for me.
>> However, on every boot, I get some warnings:
>>=20
>> ------------[ cut here ]------------
>> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 20=
8
>
> Yeah, we've seen a few reports of this.

FWIW I've tried reproducing but I don't get the error with the 8265 /
8275 chip in my laptop. I've thought about sending a patch for mac80211
to just clear the tx_time_est field after calling
ieee80211_sta_update_pending_airtime() - that should prevent any errors
from double-reporting of skbs (which is what I'm guessing is going on
here). However, it kinda feels like a band-aid so I'd much rather figure
out why this particular driver/device combo cause this :)

> I guess I kinda feel responsible for this since I merged the AQL work,
> I'll take a look as soon as I can.

Sounds good, thanks!

-Toke

