Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12443C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D083420830
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sySVSsDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbfDJNwh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:52:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53836 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730130AbfDJNwg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 09:52:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id q16so2706804wmj.3;
        Wed, 10 Apr 2019 06:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5SXLv+Fc7zC+QQAUiR2Vddbgm8c8lkdMArxvY9Gq07k=;
        b=sySVSsDOmMhA/ch+jwJyOGr449Rj+b0QcwIg0VLlsP4Tikcjmw310lH4dV/L30DM3s
         vAvecPFKBu5vom3T3SHNkXdDUIxidKANz5zqtI6a02ZXLd+DCWgba82mX1VIE6l+cpSz
         4+jUPVrSQB5DkMR2Qj2zAARUOPLAhC3RMP1wTPcF4lcNEpsmIFNsmuzzqbCL2soDWvDv
         VhcqitMuLqEGdo6M3Hcablqia31eOYXW9EGgo6VxYEbh+9eHK2Wq2/7JFZkhBVfuJd/k
         5om3XOOdycl1UcMWSH+4yb3i2feIATOCBGFEh+YyZM8a5MplICObf7bspT8DnTo6vABp
         pTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5SXLv+Fc7zC+QQAUiR2Vddbgm8c8lkdMArxvY9Gq07k=;
        b=egyBfjKUx8RxhQGl6R+HG1SZ39WlwkySuHmKI2FrL/0noHdPF34usoB213IQtLQs0F
         nAj55eaAzPmNxsn2vCSlpL9dPNtQrC4fWrzC5qB1c+QB7YceLSTNf//ys3IDHESzXUtc
         ISBUWXONmoJ9dcYqTtV1lT7wdhitf2YYVWFM3b4PZDwd13d1lX1YHknzN+hozZyUPYrj
         tSuUXpig7ffwBSCTbVt1KsYIcfahAwbZlBd96mJONthgh4mnt8li6Kqu6xD7ST2TjoVR
         u3GEL0T7k3fiDF6ZUFZYLuuYNjnNNYkoDkIKkYeecdNHiElrd5yCbjYt2MlghjSTCKWD
         jgcQ==
X-Gm-Message-State: APjAAAXgax20Hsbi4Whds17bIFp58opbJ+rJzwnsRg70VfJ7J76hgCzO
        QgudsvCRLISzyV80LkbV2xs=
X-Google-Smtp-Source: APXvYqxAuYugXPE+sWMlPJQEZINeJlhTg4ckfOgRDmjQrd/vSptza0M04CfeaqGc3DGAovnO4isyHw==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr2156724wmk.9.1554904354576;
        Wed, 10 Apr 2019 06:52:34 -0700 (PDT)
Received: from localhost ([37.238.188.7])
        by smtp.gmail.com with ESMTPSA id x5sm35688410wrt.72.2019.04.10.06.52.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Apr 2019 06:52:33 -0700 (PDT)
Date:   Wed, 10 Apr 2019 16:51:06 +0300
From:   Mohammad Rasim <mohammad.rasim96@gmail.com>
To:     brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: BCM4335 though sdio is not fully restarted after rmmod and modprobe
Message-ID: <20190410135106.jiiqehu33dvrusb7@manjaro.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
I'm running mainline linux (5.1.0-rc2 to be precise) on an amlogic
board, the board comes with Ampak AP6335 combo (so the wifi is BCM4335 over SDIO).
The firmware for this chip is already shipped by linux-firmware as brcmfmac4335-sdio.bin
but one thing that's missing is the nvram settings so I grapped the
nvram txt file from the vendor package(it can be found in [0]) and
placed it in the path that the driver is expecting, and the dongle is
working and I can scan for APs, the problem I have now is when run rmmod
followed by modprobe, the chip is not restarted and I get errors and no
wlan0 interface

after running `rmmod brcmfmac` I get these errors:

[  745.955312] ieee80211 phy0: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  745.958211] ieee80211 phy0: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  745.968443] ieee80211 phy0: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  745.973286] ieee80211 phy0: brcmf_cfg80211_get_channel: chanspec failed (-5)

and after that I run `modprobe brcmfmac` I get these errors:

[  781.529964] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4335-sdio for chip BCM4335/1
[  784.355265] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[  784.361630] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
[  784.364787] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
[  784.370677] brcmfmac: brcmf_sdio_readshared: unable to obtain sdpcm_shared info: rv=-110 (addr=0x0)
[  784.379667] ieee80211 phy1: brcmf_bus_started: failed: -110
[  784.385174] ieee80211 phy1: brcmf_attach: dongle is not responding: err=-110
[  784.429042] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
[  784.432217] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed
[  784.443484] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
[  784.446325] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
[  784.452322] brcmfmac: brcmf_sdio_readshared: unable to obtain sdpcm_shared info: rv=-110 (addr=0x0)


Any idea what's causing this ?

[0] https://github.com/kszaq/brcmfmac_sdio-firmware-aml/blob/master/firmware/brcm/nvram_bcm4335.txt

