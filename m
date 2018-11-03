Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF8EECDE44
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 20:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42CA020843
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 20:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwEf7qnn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42CA020843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbeKDFYR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 01:24:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44627 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbeKDFYR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 01:24:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id m18-v6so3507925lfl.11;
        Sat, 03 Nov 2018 13:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2pK44snJ4RRuPLwcuSjN0g5Q+pXa97n44tuvBH2HRyg=;
        b=IwEf7qnnHj75hwk5DSde5xn8gebmL4E/DgDilokZjyujxlIspsW8ILMH8dDD46wU6M
         Oa6BerUtbPHCSRkCMW9SIKqOrQXdjQG0d+Q1pf8jHPQskHrrevsmEy/rYR2LWQxOOm6m
         OcmOpjYApBFEdH5ynnaE9g2yJevJxt96zoomATCf3Lz+6wQny/a0qnCNEuMKPPLuUpxr
         y2KudQqLH20gwjYb/4e8UXX5smuaa48wOOE6Jn/rcvg8SwAH/mLXqj6YyXFy/OQv0FtR
         Lgd6snpRRLQfa3iX1UmahTarHLtpDRKwAeO0AYBLD2ghXM9wsHyVRNnPoAG/prCW5fOv
         SLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2pK44snJ4RRuPLwcuSjN0g5Q+pXa97n44tuvBH2HRyg=;
        b=lERozS80geybpD7VIAUozrzmlgF3nwrfBuzIYnweQcscAm6fDcsiWe7vMRFigHaqTf
         +Lffjyri1H9Ry+toEwfo8ZJcUAefGSdjNqc3/BN3u7AdIXB9bJBgSYtMKjuQIHzZuAcf
         pKl514Gnz0inMmkRr+O54pQxEw3JXiUAjTB7c44cKV8MXPvaqJLqaVp4prjMNl3n3CgP
         bBfPYfkzXoFmiwAPM6QZBJlCgXNpaltz/9d+WsCuKyqgSGECg/p7koYfFnxWf3l2aetu
         LZXh4XNvAD3aFDXBztiOzagpYjsXivLUA/A7KEYlToC84qzgM/Ffhj4tThOIJN0dNmix
         Fp4Q==
X-Gm-Message-State: AGRZ1gKx7IyyZtxRg15FHdmjzvCdhfRARp2ROweBEMDnqw2bRsPQNQTX
        qzR1LTXx2mLaNRWZLQk2CwZk8ckT8CecE0B9Gw==
X-Google-Smtp-Source: AJdET5cvDGEE9HnV6uejs+sCHsz0mbh2kXtPLWaRQ3V7hJl69OH/lhhKA73fc2B/w/ZNHs0OXq5ko9EmWKt1NCEEzN4=
X-Received: by 2002:a19:2106:: with SMTP id h6mr9291390lfh.29.1541275917130;
 Sat, 03 Nov 2018 13:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAEJqkgiKzYTZQTGWNAPTeOPFWz658FWqDsAhyoxVDP1VKWSukg@mail.gmail.com>
In-Reply-To: <CAEJqkgiKzYTZQTGWNAPTeOPFWz658FWqDsAhyoxVDP1VKWSukg@mail.gmail.com>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Sat, 3 Nov 2018 21:11:31 +0100
Message-ID: <CAEJqkgh7xksO7tmPHGkOXvWftc2AcCgi4j3S3C88CorV53+Hgw@mail.gmail.com>
Subject: Re: atk10k Unknown eventid and WARN() on resume with kernel 4.19
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, dex77@frugalware.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am Sa., 3. Nov. 2018 um 21:01 Uhr schrieb Gabriel C <nix.or.die@gmail.com>:
>
> Hello,
>
> starting with kernel 4.19 we noticed  'Unknown eventid: xxxx' warnings
> on our Laptops.
>
> ...
>
> crazy@devnull:~$ dmesg | grep Unknow
> [    7.144998] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [    7.147758] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> [    9.441654] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [    9.444446] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> [   11.770997] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [   11.773787] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> [320339.374108] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [320339.377020] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> [320342.128664] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [320342.131447] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> [320344.452864] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> [320344.455696] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
>
> ....
>
> Both boxes also hits the following WARN*() on resume from S3:
>
 Uh sorry .. Gmail doesn't like long lines it seems.
There the WARN() message:

http://ftp.frugalware.org/pub/other/people/crazy/warn.txt

>
> Please let me know if you need an dmesg or any other informations.
>
> BR ,
>
> Gabriel C.
