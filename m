Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD33C282CE
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 21:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D581D2070D
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 21:39:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjVdcd8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfDNVjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 17:39:23 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:39605 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfDNVjX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 17:39:23 -0400
Received: by mail-qt1-f182.google.com with SMTP id t28so17051311qte.6;
        Sun, 14 Apr 2019 14:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Wn5UCSU/NJP18QQnduXwUcQrqOK90WvjGyWteZKn/I0=;
        b=pjVdcd8dvzarVvlKq9wIprJI48gcoRxjMj5JgBSxR1OOPeZ5zBy1+M60V40EVnJ/38
         riFkRr3PwRCz27vmmUmHnwxAcgVq1S+rYxKu8HbZOPQxh6D2bFerWq71u1Rvr2h/ppDx
         /6lu3ZGfGJoG6C3TgZ/kteijqBCVmahXAjuhEsAZZIPqTb4YHoEsxDVeRLJorD3g3Wrv
         KJwm7j1CvRU9FkhurbayAE9ZsSUh0qDbpzbxdFVUgoPyjvzA1QigjnpcbX5L67jf7x8X
         FQk9aU3Y6LBI7xcrhOPOBxjXbs/DHMgeKYhJ0g9XiWFzW3k/H/EoUFJNHYbVC4TdaaEa
         prHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Wn5UCSU/NJP18QQnduXwUcQrqOK90WvjGyWteZKn/I0=;
        b=A5vU5+k4LmNgNEfWEUd6i0n77yznAI6tjZesDUCNJZGP6l6ebz3JdBpb5J0rVX8K5x
         zvKOlMmfC9Tthk2YyazXDpbVLtiRtDQ2gX2MxXT7LL7uxzGhNyCdf1A5RiNZf8CPmn8Z
         bGFSltt4LYg3YsU0iGus5bJkZ+jboUnTDHsJBwGFkpfcUPkRI2CfMrY6X2LWVtXKjE4c
         LMd7BpIBee4tbSjhoOdSb4TerrWTJsD7l9cI2KbE9O+VcR5XFtyUrp4zQ91CwjPGmHs4
         mw+8Vqn5jNYnkhF8pqUBdIlwpVkhhJjabebwGTRGdvjWwC/B/Dhni4T2wDMNEVFzfRwL
         Hoqw==
X-Gm-Message-State: APjAAAWAVlVa0A1m+ZDHepnP75VDJgWlebeYpciht7eNCtdwaj+OGWZe
        xlLWZrYmDJmkDPOu28HLOXb+9WPN
X-Google-Smtp-Source: APXvYqxJ3XE6M6/Pol/kS71NNIsGA/BhdPseRHva24J0UHCfJjFqLQQYBtwl/OobuarxZfNuZYe5OQ==
X-Received: by 2002:a0c:b6d4:: with SMTP id h20mr47999793qve.48.1555277961757;
        Sun, 14 Apr 2019 14:39:21 -0700 (PDT)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id t34sm41052690qth.36.2019.04.14.14.39.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Apr 2019 14:39:21 -0700 (PDT)
Subject: rtlwifi-new v0.6 and dkms failures
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <60509a60-d0ea-d17f-8b79-e51c374717ba@gmail.com>
Date:   Sun, 14 Apr 2019 17:39:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

Thanks for your prior assistance with the rtw88 module.=C2=A0 Since manua=
lly
compiling and installing works correctly, I have been working to
register the software in dkms, but am running into some difficulties.=C2=A0=

Below are some snippets from a terminal session to illustrate the issue:

udo dkms install rtlwifi-new/0.6

Creating symlink /var/lib/dkms/rtlwifi-new/0.6/source ->
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /usr/src/rtlwifi-new-0.6

DKMS: add completed.

Kernel preparation unnecessary for this kernel.=C2=A0 Skipping...

Building module:
cleaning build area....(bad exit status: 2)
make -j12 KERNELRELEASE=3D5.0.0-11-lowlatency -C
/lib/modules/5.0.0-11-lowlatency/build
M=3D/var/lib/dkms/rtlwifi-new/0.6/build....
ERROR (dkms apport): binary package for rtlwifi-new: 0.6 not found
Error!=C2=A0 Build of rtl_pci.ko failed for: 5.0.0-11-lowlatency (x86_64)=

Consult the make.log in the build directory
/var/lib/dkms/rtlwifi-new/0.6/build/ for more information.

Below is the make.log contents referenced above:

DKMS make.log for rtlwifi-new-0.6 for kernel 5.0.0-11-lowlatency (x86_64)=

Sun 14 Apr 2019 05:25:37 PM EDT
make: Entering directory '/usr/src/linux-headers-5.0.0-11-lowlatency'
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/main.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/mac80211.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/util.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/debug.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/tx.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rx.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/mac.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/phy.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/efuse.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/fw.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/ps.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/sec.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/regd.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822b.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822b_table.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822c.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822c_table.o
=C2=A0 CC [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/pci.o
=C2=A0 LD [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtwpci.o
=C2=A0 LD [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw88.o
=C2=A0 Building modules, stage 2.
=C2=A0 MODPOST 2 modules
=C2=A0 CC=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/bui=
ld/rtw88.mod.o
=C2=A0 CC=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/bui=
ld/rtwpci.mod.o
=C2=A0 LD [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtw88.ko
=C2=A0 LD [M]=C2=A0 /var/lib/dkms/rtlwifi-new/0.6/build/rtwpci.ko
make: Leaving directory '/usr/src/linux-headers-5.0.0-11-lowlatency'

As you can see, the make log does not show any errors, which is baffling
to me.=C2=A0 Any insight you have on resolving this issue would be apprec=
iated.

Sincerely,

David R. Bergstein


