Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DC7C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 18:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46E5320657
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 18:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iV7qL+oJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfAISjq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:39:46 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45875 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfAISjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 13:39:46 -0500
Received: by mail-io1-f66.google.com with SMTP id c2so6800662iom.12;
        Wed, 09 Jan 2019 10:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fmf/TfTxuawXWTvVxRSfpf0/tBlX9ecoGigM7B99ZF4=;
        b=iV7qL+oJdDB1TA0Vouno6h01gGPy7veFjwaWN4h3Q5oO4xozIVesgDbKQn8SAGqAMK
         k8KojD6ITghH8LzCfS34kVnavpO1nbpQxX7E/zrZHqn77e8eYLomdkXcpBrZg3Jod0D9
         mML1/tmTEbMfHYrGQTG1xtKKCbbEDR+drXhChCmDC47TCWIk1rHZ82hVxXfie0lBmgO+
         udrxmaebGsI/0sUIolpK/AFZWUmMxKMZgF8PMXkHcZeiwKAfBmur3RSi84vPmAHLJZxB
         wP5rJcUkrpdIRULtXDQuhboaAs5Pn+fTZdUN/Tm9eYt/GAEiBuBcHozPxIwwoWtzWB4w
         SYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fmf/TfTxuawXWTvVxRSfpf0/tBlX9ecoGigM7B99ZF4=;
        b=WhoNK7+EwCbYq+d/ShTQmqkv66E2Bnk0Yfi3Fp7bIG9ilQvXiT7Kj1Drq/8wAVYeSi
         iycgA/XGVcjAu9f+u7A3SXta5lLnGYm19vdZqa7vRYFC6+DG/42Po9g5zrthAHQFTYLe
         qdMxKOq7QHtURagiQrW2bpxA4njtuikIV9pCw9/C7GmwWV2c+WZWQdg9TmEzTJmWJI9x
         mhI49jV57mEA+IWnYiJLoyrqcSr/o+kxtT/i3i7oioq8fs1Fy4Cp91uTjSgSvdLQqBzg
         +ilrjtRXNFKVynmRc4qBvRqYZhWPwootvDvkjnV2M3PRwexeCZP6QQWQSlkiHSmhgz0m
         tarQ==
X-Gm-Message-State: AJcUukd46xGYibdVuV6LOX18uEI7nL7fFOBYixHOVDXAar5X0klz6pDb
        CJKPQDPbr/YSzgHS2a5O9BIGtkRROzA2du1Gxrc=
X-Google-Smtp-Source: ALg8bN5HWzEPv9/lVhkkfbni851iyYVD/gEn5rHRo4RMHjsPksMWVL6QyDyvG0pnF2RuAbqdxd1at3vQ5skKrBxvxDQ=
X-Received: by 2002:a6b:c8c9:: with SMTP id y192mr4335916iof.183.1547059185036;
 Wed, 09 Jan 2019 10:39:45 -0800 (PST)
MIME-Version: 1.0
References: <20181109000800.15431-1-jprvita@gmail.com> <83CA40B2-1AF3-49FA-9F94-C84A3C916583@holtmann.org>
 <CA+A7VXXfdyLWMpNaEzUzDe6PiktOKb5oJrufYrGeTyXyXChQfw@mail.gmail.com>
 <CA+A7VXX2fA5gC1_-nwFDswvB+we3R69ZTNiGDmrO+sftRdxxpg@mail.gmail.com> <CA+A7VXXarPAb+vFNTqZDhpng_niLjSCxqEQdLLV9eGAn+PPUXQ@mail.gmail.com>
In-Reply-To: <CA+A7VXXarPAb+vFNTqZDhpng_niLjSCxqEQdLLV9eGAn+PPUXQ@mail.gmail.com>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Wed, 9 Jan 2019 20:39:32 +0200
Message-ID: <CANUX_P27VP_Vy+omnO2CAGvntZNF6vowrFEHrAfeSgPrFJFdsg@mail.gmail.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
To:     =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

> > > >
> > > > our hardware teams from the Bluetooth and WiFi side really need to look at this.
> >
> > Were you able to get attention from the hardware teams with the logs
> > I've provided? Are there any news or an idea of when / if we can
> > expect this to be fixed in firmware? If not, do you have suggestions
> > for an alternative solution?
> >
>
> Sorry to bother you again with this, but I'd really like to figure out
> some way forward here. Did you get any feedback from the hardware
> teams? Otherwise, I understand having an inter-dependency between the
> wifi and bt kernel modules is not desirable, so do you have any
> suggestion on how to solve this without adding this dependency?
>

Have you tried the update the BT firmware with what is now available in
mainline linux-firmware.git?
I heard that this problem has now been resolved. After you update the
BT firmware, you need a full power cycle.
