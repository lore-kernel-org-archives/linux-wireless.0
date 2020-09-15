Return-Path: <SRS0=aUvw=CY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDAFC433E2
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Sep 2020 09:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BF32078D
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Sep 2020 09:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bax+prDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgIOJYq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Sep 2020 05:24:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgIOJYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Sep 2020 05:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600161880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ngvCaS1ILB4OhzWsZuPqCMvo8JpQUYEi2PT/bvPX1P8=;
        b=Bax+prDpvZ3BiHHVtf9iJvrje/aolqxAPKUhrYByFVRxC88rq7Mv313MFp9Cub/ak6gaB6
        Vzoer/xDn1FA/Z/1fx7SeAKxMEqhRHL8/xdfg8xqVjRBujQ/+MbmC2q5BbLz9QfPIvLfm8
        YZ9a5zxOeY8eFaz6AOxO+Rh1mjylFAU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-Qsrk5Kk3MZWTSJo4SzBDXA-1; Tue, 15 Sep 2020 05:24:38 -0400
X-MC-Unique: Qsrk5Kk3MZWTSJo4SzBDXA-1
Received: by mail-wm1-f71.google.com with SMTP id l15so674022wmh.9
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2020 02:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ngvCaS1ILB4OhzWsZuPqCMvo8JpQUYEi2PT/bvPX1P8=;
        b=BPPy9TytPMflqy4dyksXgS9F/eRP7ragI+3aIRBMlGfNfpP+L2MCz6yFNuaFg1qrp0
         XdDY7sGJr/u3TigMPoTjJm44Md0nX4oWNPPzNsR7Z1eZtK3huk9gBHnvJe8Hk7jwWuGU
         SOej1Kh2zsVZ5/Ep3UJQFWo7EobnF5eDBMCfkxdt7WT+37AQexYP8TCNLO4Ew4+MKXCF
         PhbyXXtXtHbMt5rd5NEa4SuCG3ScuNnIcZTJJQiTdvIx2Z85T5troHZRGFusoHT9cS3/
         j2Kji4jmo1kf+yAoYDv9+Kk44Z5Vco0hvqr7BLoRew0o2s/oOCGGy/0uOycipfJTv0nU
         dm4Q==
X-Gm-Message-State: AOAM531SCsDNzfZBM+N+sESeP/gygs13aCPlal0q1xC08mehJDx4GVjO
        DN7T9zev6xEJuI4eauaDjxqJf8jiLpq0d6X10pVQMn5qZZeW1R+7m2dgwCVpdnDwp0Y6DFCg70x
        z9t6IgyJonE03NYJ5mlbdFUKtNLE=
X-Received: by 2002:a1c:9893:: with SMTP id a141mr3723025wme.188.1600161877018;
        Tue, 15 Sep 2020 02:24:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKbwZybnmfQrbnfdYHn7BFt8JQZ0Cz/rHdcuTw+oLOoTvDnH3mOiPGUb7JPDLXPG1/ajDMkw==
X-Received: by 2002:a1c:9893:: with SMTP id a141mr3723003wme.188.1600161876756;
        Tue, 15 Sep 2020 02:24:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z83sm24635336wmb.4.2020.09.15.02.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 02:24:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EE4761829CB; Tue, 15 Sep 2020 11:24:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [PATCH 5.9 v2 2/2] mac80211: add AQL support for VHT160 tx rates
In-Reply-To: <20200915085945.3782-2-nbd@nbd.name>
References: <20200915085945.3782-1-nbd@nbd.name>
 <20200915085945.3782-2-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Sep 2020 11:24:34 +0200
Message-ID: <87a6xrz92l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> When converting from struct ieee80211_tx_rate to ieee80211_rx_status,
> there was one check missing to fill in the bandwidth for 160 MHz
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

