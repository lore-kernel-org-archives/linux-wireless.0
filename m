Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33888 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbLTVew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 16:34:52 -0500
Received: by mail-ig0-f179.google.com with SMTP id m11so21057126igk.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 13:34:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5677109E.1000209@sigmadrone.org>
References: <5677109E.1000209@sigmadrone.org>
Date: Sun, 20 Dec 2015 22:34:51 +0100
Message-ID: <CACna6rwPa3akf5u3WwxtJVsuEdW986JHkk0NDOSVCzY_C3DLew@mail.gmail.com> (sfid-20151220_223455_533229_F236E79A)
Subject: Re: Broadcom AP failure
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Martin Stoilov <martin@sigmadrone.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 December 2015 at 21:33, Martin Stoilov <martin@sigmadrone.org> wrote:
> I am running AP with Broadcom 4330. Occasionally, I am getting failures with
> the following stack trace. Any idea what the problem might be here?
>
> Best Regards,
> -Martin
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 550 at
> /home/mstoilov/workspace-yocto/fsl-community-bsp/build-colibri-lsb/tmp/work-shared/colibri/kernel-source/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:1076
> brcmf_netdev_wait_pend8021x+0xe8/0xfc [brcmfmac]()

It was reported once in e-mail thread [0] [1]:
WARNING: brcmfmac/core.c:1144 brcmf_netdev_wait_pend8021x

It was most likely fixed by the following patchset [2] [3]:
[PATCH 00/12] brcmfmac: multiple interface rework and cleanup

[0] https://marc.info/?t=143646507500003&r=1&w=4
[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/139828
[3] https://marc.info/?t=144062024700017&r=1&w=2
[4] http://article.gmane.org/gmane.linux.kernel.wireless.general/141389/match=brcmfmac
