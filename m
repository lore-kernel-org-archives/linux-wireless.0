Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EDFC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F5320873
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547480036;
	bh=rILbio75XpXLMh64q13lG+kLdW5B4O0d9+ig/TZAdbo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gzDWsybS5nGkBAmRElqpAdV1jrvJyzoSZ0lI5EerFYLPghmbxnN5JhWiIrk74KzEC
	 dj2bqhYLDYuF1KvC8Rtyq03DqctaogslrJp0Q2OURdcxEKVTRjaQLB9tsBunYabmKh
	 J9zzl0IQJ/gW8BWri9NRHGqfiZ5ZkH+jhgnCKZlM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfANPdz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfANPdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 10:33:55 -0500
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C270620989
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 15:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547480034;
        bh=rILbio75XpXLMh64q13lG+kLdW5B4O0d9+ig/TZAdbo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dyDMeM2TMBdToMR4a1NyVFue7+wM/SkhCM0hKml6IWW2TIomgVBhSZrr2n2b9RnGk
         97gtbZPNYqJI1EHnHLRTNrGKs8WEriynx/BlSIropChaJDVdqtUh0locRsEjgBYKXc
         TpopvJ2voAMo4iPoNHx4Gmq7PMStEcuGe70ZwDO4=
Received: by mail-qk1-f177.google.com with SMTP id q8so10759756qke.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 07:33:54 -0800 (PST)
X-Gm-Message-State: AJcUukcjrQSM4yOKd+0oIhGT/qdnhB9Dde4WR2OjC/ZEAE/H218Evck9
        AihLJK6czyI2y6kLuSYX5NevpnC9HTVTvmEz7Dc=
X-Google-Smtp-Source: ALg8bN6FqDTBWTHD9H4hv/yrdN/CGIKpy4nKppVi92BLeZSGPNG3sbCDAIitsU3uI9EjGN+HmkPt/X3Wzcn3nAcU1PY=
X-Received: by 2002:a37:bb82:: with SMTP id l124mr22277189qkf.188.1547480033897;
 Mon, 14 Jan 2019 07:33:53 -0800 (PST)
MIME-Version: 1.0
References: <52ec533a-bd4e-71b4-7bcd-8f2791dec564@suse.com>
In-Reply-To: <52ec533a-bd4e-71b4-7bcd-8f2791dec564@suse.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 14 Jan 2019 10:33:42 -0500
X-Gmail-Original-Message-ID: <CA+5PVA56=0x8r67SP1Z6x4QnSjm=Qz9GXjSXuCv+At9-C4kQWA@mail.gmail.com>
Message-ID: <CA+5PVA56=0x8r67SP1Z6x4QnSjm=Qz9GXjSXuCv+At9-C4kQWA@mail.gmail.com>
Subject: Re: [GIT PULL] Add NVRAM files for bcm43455 and bcm43430
To:     Matthias Brugger <mbrugger@suse.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        serge@raspberrypi.org, phil@raspberrypi.org,
        Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 11, 2019 at 7:11 AM Matthias Brugger <mbrugger@suse.com> wrote:
>
> Hi Josh,
> Hi all,
>
> This pull request add firmware files neede by bcm43430 for Raspberry Pi 3 Model
> B and bcm43455 for Raspberry Pi 3 Model B+.
>
> Please have a look and, if convenient, pull :)
>
> Best regards,
> Matthias
>
> ---
> The following changes since commit 0f22c8527439eaaf5c3fcf87b31c89445b6fa84d:
>
>   Revert "amdgpu: update vega10 fw for 18.50 release" (2018-12-18 15:38:53 -0500)
>
> are available in the Git repository at:
>
>
> ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/matthias.bgg/linux-firmware.git/
> tags/add-rpi-fw
>
> for you to fetch changes up to 930f276f8f1f2d83e44da6a32f4e0b2513db21a2:
>
>   brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B (2019-01-11 13:04:43
> +0100)
>
> ----------------------------------------------------------------
> - Add NVRAM for BCM43455 used by Raspberry Pi 3 Model B+
> - Add NVRAM for BCM43430 used by Raspberry Pi 3 Model B
>
> ----------------------------------------------------------------
> Matthias Brugger (2):
>       brcm: Add BCM43455 NVRAM for Raspberry Pi 3 B+
>       brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B
>
>  WHENCE                                      |   3 +
>  brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt |  47 ++++++++++++++++
>  brcm/brcmfmac43455-sdio.clm_blob            | Bin 0 -> 14036 bytes
>  brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt |  82 ++++++++++++++++++++++++++++
>  4 files changed, 132 insertions(+)
>  create mode 100644 brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt
>  create mode 100644 brcm/brcmfmac43455-sdio.clm_blob
>  create mode 100644 brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt

Pulled and pushed out.

josh
