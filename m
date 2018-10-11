Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED3FC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D287D204EC
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r7f+b0XX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D287D204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbeJKUG2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:06:28 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44141 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbeJKUG2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 16:06:28 -0400
Received: by mail-oi1-f193.google.com with SMTP id u74-v6so6868909oia.11
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 05:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Auo5TLbdGRPQSaGDX36iQvqqbWbef8wig9pzIYCVE5g=;
        b=r7f+b0XXf7F/Z5SnTDsWRANFwlSuIjGyBjoemC0/GhFKmZ11xlgUZKb1nvbrz5H4W6
         dleLhlM2I9lN6CQFO7GtwkhCPE5g/MtmFRqnR3rI/d66+6cBSm8ibwJ5gFE7lMpkcVLc
         WkBvrSTW2RZEdQSYgOxoUMD0k8ivLhuuIrTsJdmUlFiCeglqvkbImEPI2ZH42g0pWtGz
         gbJh5wGWd9+VtNH1+sPb0MWYrvH02JFhuU/cO8MuQTYzhZJV7WDG6v1hf/iB+4jhSuHS
         4srTAj8fCgEEubiYwRykhDguF+j2o/PZGBu/PtbBaWhHDMrsD+8Zr+YLDfjn8xvuBLRf
         X32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Auo5TLbdGRPQSaGDX36iQvqqbWbef8wig9pzIYCVE5g=;
        b=DmPSrn4zgNF6bhTWQu74WQjaZYKvToQ41ObbpD89rdNU7XTXNBm+WeDZFNSF/di4Hk
         pymm8YwjN9pC+ACy2n5ffh5B9XiX2zBrcoZwUgztCEu3wbt+38Z+mQwkyr7n+U7QXjDI
         cVJqxKQCx7zggb/vpy2+t9JMTVUFSBbC/lrGaiiEYru2rUea9NhNt+amg0IUMHIR+MFQ
         ozuYRwvBYh4EBXpGKk+MD0VhFoSq+ygHDG0qCz64pdI9bxQ8s4LPGk3j16ye6gWF5IH1
         leCloieeDPm7g/wEWeEafh8nJ74rXWXcib2Cz13iH5ikmlGILNcVsi96CHHd4HO+iREl
         KatA==
X-Gm-Message-State: ABuFfoh6Xn91nV+j/Ka4QD0awd4mKInWthtt466naJo1VLcpS1XPtFPA
        p/Vbaz6VbZl48xEJt7AQ4ubxdyNPxpjgZ+yi7co=
X-Google-Smtp-Source: ACcGV61ed3WZuLAiCTYet66yikKDHiHUeFMVFlpSLdRWUhHtlhA05VCtPH2LXvxjvA+PsI5D81HyAs1Oom8YgEUnWRo=
X-Received: by 2002:aca:484a:: with SMTP id v71-v6mr771065oia.163.1539261565926;
 Thu, 11 Oct 2018 05:39:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Thu, 11 Oct 2018 05:39:25
 -0700 (PDT)
In-Reply-To: <20181011100524.GA20794@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com> <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com> <20181010120657.GA1185@makrotopia.org>
 <20181010124508.GA22330@redhat.com> <CAKR_QVJbtzpu6v4bZEz2UegWiAy1Ohooy-TciZcOeR_p+Z+yYg@mail.gmail.com>
 <20181010154054.GA27779@redhat.com> <CAKR_QVLjFyGtzikLTiQKhrVBSyUoPmDn2tMJqto8dyBDjoFJOQ@mail.gmail.com>
 <20181011100524.GA20794@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 11 Oct 2018 14:39:25 +0200
Message-ID: <CAKR_QVJJJKgtip3386yM1EW+3UV8e=DvFf-qtmw7vRFggS1FHg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

so this is RX test where I assume your 7265 card is sending data. is
that HT20 or HT40 mode and do you get regression on TX too?

can you try same case 2 test but with registers set to:

TX_SW_CFG0, 0x00000401
TX_SW_CFG1, 0x000C0000
TX_SW_CFG2, 0x00000000 (or 0x000C0408)

did you ever notice any tx power difference between nexx fw and openwrt fw?

On 11/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Oct 10, 2018 at 10:03:12PM +0200, Tom Psyborg wrote:
>> ok, that is strange. do you see any performance differences without
>> TX_SW_CFG regs? iperf test is a good pointer.
>>
>> this was a problem on xiaomi mini with old DD trunk builds on 4.4
>> kernel and LEDE builds from last year. i ain't got no chance to try
>> this on 18.06. which device you tried this on? if ipa/ilna it might
>> make no difference
>
> No diffrence for me. I have nexx wt3020 8M.
>
> However I notice this set couse performance regression for me.
> When connecting to iwl 7265 . Without the set I have:
>
> root@LEDE:~# iperf3 -c 192.168.10.243
> Connecting to host 192.168.10.243, port 5201
> [  5] local 192.168.10.1 port 59304 connected to 192.168.10.243 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  5.37 MBytes  44.9 Mbits/sec    0    279 KBytes
>
> [  5]   1.00-2.00   sec  5.80 MBytes  48.8 Mbits/sec    0    494 KBytes
>
> [  5]   2.00-3.00   sec  6.03 MBytes  50.5 Mbits/sec    0    513 KBytes
>
> [  5]   3.00-4.01   sec  5.90 MBytes  49.2 Mbits/sec    0    513 KBytes
>
> [  5]   4.01-5.01   sec  5.90 MBytes  49.5 Mbits/sec    0    515 KBytes
>
> [  5]   5.01-6.00   sec  5.78 MBytes  48.9 Mbits/sec    0    515 KBytes
>
> [  5]   6.00-7.00   sec  5.66 MBytes  47.4 Mbits/sec    0    515 KBytes
>
> [  5]   7.00-8.00   sec  6.03 MBytes  50.6 Mbits/sec    0    515 KBytes
>
> [  5]   8.00-9.00   sec  6.09 MBytes  50.9 Mbits/sec    0    515 KBytes
>
> [  5]   9.00-10.00  sec  5.72 MBytes  48.2 Mbits/sec    0    515 KBytes
>
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  58.3 MBytes  48.9 Mbits/sec    0
> sender
> [  5]   0.00-10.00  sec  58.3 MBytes  48.9 Mbits/sec
> receiver
>
> With the set I have:
>
> root@LEDE:~# iperf3  -c 192.168.10.243
> Connecting to host 192.168.10.243, port 5201
> [  5] local 192.168.10.1 port 45824 connected to 192.168.10.243 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  3.78 MBytes  31.7 Mbits/sec    0    197 KBytes
> [  5]   1.00-2.00   sec  3.71 MBytes  31.0 Mbits/sec    0    369 KBytes
> [  5]   2.00-3.00   sec  3.51 MBytes  29.5 Mbits/sec    0    484 KBytes
> [  5]   3.00-4.00   sec  3.36 MBytes  28.1 Mbits/sec    0    519 KBytes
> [  5]   4.00-5.00   sec  4.10 MBytes  34.4 Mbits/sec    0    519 KBytes
> [  5]   5.00-6.00   sec  3.73 MBytes  31.2 Mbits/sec    0    519 KBytes
> [  5]   6.00-7.00   sec  4.29 MBytes  36.0 Mbits/sec    0    519 KBytes
> [  5]   7.00-8.00   sec  4.16 MBytes  34.9 Mbits/sec    0    519 KBytes
> [  5]   8.00-9.00   sec  4.35 MBytes  36.5 Mbits/sec    0    519 KBytes
> [  5]   9.00-10.00  sec  4.41 MBytes  37.0 Mbits/sec    0    519 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  39.4 MBytes  33.0 Mbits/sec    0
> sender
> [  5]   0.00-10.00  sec  39.4 MBytes  33.0 Mbits/sec
> receiver
>
>
> Stanislaw
>
>
