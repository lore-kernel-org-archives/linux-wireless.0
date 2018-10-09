Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA17ECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C51C214C4
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DZQ2Vxrc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C51C214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbeJJCRy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:17:54 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33190 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJJCRy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 22:17:54 -0400
Received: by mail-yw1-f67.google.com with SMTP id m127-v6so1126850ywb.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 11:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zqK6U1P4AhXWWh5YdH/nvJy4Pva1ZhMflVkM8G3RCwM=;
        b=DZQ2VxrcjvqIRee88PCL8tKb+mqYTscls2trKvFnOUOOITZApRQ5cHS6mzjKTCiXpJ
         TJ0wnZ1HclQYKdnFBx5XRLQzk9UGUUBH34mh4sFnIK1hXEhkWC8x0Nt96yXkqIGpVlf6
         e62m7LOhOYybrX6ONuHMFGrJIxRXdheKAMBDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zqK6U1P4AhXWWh5YdH/nvJy4Pva1ZhMflVkM8G3RCwM=;
        b=f15eTbxBfJLNpgbobLjdzPByKTAh7NTXNJhVGILq7QTzAKfpn+L5Jnc3ch1RNOUWgr
         OceWA62CbXRvH9BcMX08Gs5Jky3s5sJlZaar4J72xifs70IrGAEiZlIl4g+z2vx0OhiS
         DqzKj2XlIzUlovqVvRajLxUjYAiivoIqwXp+s/7jE9zg6GMvc7sMBqAtMt9VBZnPmjt+
         6aYgDLWp4cIHeehrU42AQNKQnUFgxxDG9MBOMUvO15OPHQf39XDBa60mhETN37g4phXQ
         At/rluF8+7rAJKIzdGBDXADk6NCUg6hBYe5/csTdYg3Nmi50piyFnYNeZ6SxAeSr8D0C
         UoHQ==
X-Gm-Message-State: ABuFfogyJz7c+CK5efV5Dz3mRdum24vFPjmfY0yKpXkz+A2ySEIHtXGA
        D7EMpFiUgs5tb59Q8XRtTh5fnP/TUxet3QUFsBLoHA==
X-Google-Smtp-Source: ACcGV626FFnQ9jTWnCnDgFogzXhC1CCCs4UPTmRYJN9kMH3gWgk+BNdrrmaoD2NR/2IHljfPU0xsNkZ/d83VravlfhQ=
X-Received: by 2002:a81:2fd4:: with SMTP id v203-v6mr16281384ywv.199.1539111570402;
 Tue, 09 Oct 2018 11:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
In-Reply-To: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Tue, 9 Oct 2018 11:59:19 -0700
Message-ID: <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     christoph.muellner@theobroma-systems.com
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Christoph,

On Tue, Oct 9, 2018 at 11:10 AM Christoph M=C3=BCllner
<christoph.muellner@theobroma-systems.com> wrote:
>
> Hi Arend,
>
> recently I got an SDIO module, which includes a BCM4359.
> I tried to get it up and running via the SD card interface
> on a RK3399 SoC and succeeded in doing so with
> bcmdhd.1.579.77.41.x and a vendor kernel (based on Linux 4.4).
> All that was necessary was configure BCMDHD to run with
> in-band IRQs and use a GPIO as gpio_wl_reg_on.
>
> Since I can run a mainline kernel as well, I gave it a try and
> tried brcmfmac on Linux 4.19-rc7. As the BCM4359 is not in
> the list of supported SDIO devices, but is supported USB device,
> I've created a patch (attached), which adds the support for that device.
> Additionally I've patched my DTS to include the WL_REG_ON
> pin as part of mmc-pwrseq-simple's reset-gpios and added
> a bcm4329-fmac node in the mmc node.
>
> During bootup I see messages from brcmfmac, which indicate
> that the BCM4359 has been found, but loading the nvram file
> continuously fails:
>
> > [    5.993741] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac435=
9-sdio for chip BCM4359/9
> > [...]
> > [    7.987167] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
> > [    8.008715] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading =
2048 membytes at 0x0025f1f0
> > [    8.021182] brcmfmac: brcmf_sdio_download_firmware: dongle nvram fil=
e download failed

Does it always fail at nvram verification? If so please help to get
the address and varsz in brcmf_sdio_download_nvram. Also their
equivalent in bcmdhd which should be varaddr and varsize in
dhdsdio_write_vars.

Thanks,
--Franky

> That -84 means EILSEQ, which is the error value, which represents
> a CRC error during SDIO data exchange (returned by the function dw_mci_da=
ta_complete()
> in the MMC driver).
>
> To address this, I've reduced the clock speed (in several steps) to 400 k=
Hz
> (and verified the clock signal on an oscilloscope), but the issue persist=
s.
> I've also tried to use Linux 4.14.74, where I see the same issue.
>
> I can confirm that the MMC interface works in general (I can use an SD ca=
rd
> to host my rootfs).
>
> FWIW I'm using the same exact same firmware and nvram file for the DHD dr=
iver
> and the brcmfmac.
>
> Do you have any ideas how to debug this issue?
>
> Thanks,
> Christoph
>
>
>
> --
> Christoph M=C3=BCllner
> Theobroma Systems Design und Consulting GmbH
> Seestadtstra=C3=9Fe 27 (Aspern IQ), 1220 Wien, Austria
> Phone: +43 1 236 98 93-409, Fax: +43 1 236 98 93-9
> http://www.theobroma-systems.com
>
>
>
>
