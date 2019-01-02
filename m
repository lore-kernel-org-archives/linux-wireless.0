Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB95C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 08:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CDF5218A4
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 08:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfABIhb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 03:37:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfABIhb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 03:37:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CF44C056824;
        Wed,  2 Jan 2019 08:37:31 +0000 (UTC)
Received: from localhost (ovpn-204-181.brq.redhat.com [10.40.204.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DE335C207;
        Wed,  2 Jan 2019 08:37:29 +0000 (UTC)
Date:   Wed, 2 Jan 2019 09:37:29 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        hauke@hauke-m.de, nbd@nbd.name, john@phrozen.org,
        daniel@makrotopia.org, John Crispin <blogic@openwrt.org>
Subject: Re: [PATCH 2/2] rt2x00: define RF5592 in init_eeprom routine
Message-ID: <20190102083728.GB5300@redhat.com>
References: <1545919526-4074-1-git-send-email-pozega.tomislav@gmail.com>
 <1545919526-4074-2-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1545919526-4074-2-git-send-email-pozega.tomislav@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 02 Jan 2019 08:37:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 27, 2018 at 03:05:26PM +0100, Tomislav Požega wrote:
> This patch fixes following crash on Linksys EA2750 during 5GHz wifi
> init:
> 
> [    7.955153] rt2800pci 0000:01:00.0: card - bus=0x1, slot = 0x0 irq=4
> [    7.962259] rt2800pci 0000:01:00.0: loaded eeprom from mtd device "Factory"
> [    7.969435] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5592, rev 0222 detected
> [    7.977348] ieee80211 phy0: rt2800_init_eeprom: Error - Invalid RF chipset 0x0000 detected
> [    7.985793] ieee80211 phy0: rt2x00lib_probe_dev: Error - Failed to allocate device
> [    7.993569] CPU 0 Unable to handle kernel paging request at virtual address 00000024, epc == 800c8f54, ra == 80249ff8
> [    8.004408] Oops[#1]:
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 7f813f6..86770e8 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -8839,6 +8839,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  		rf = RF3322;
>  	else if (rt2x00_rt(rt2x00dev, RT5350))
>  		rf = RF5350;
> +	else if (rt2x00_rt(rt2x00dev, RT5592))
> +		rf = RF5592;

This looks like workaround for the crash and AFICT it is not needed
on upstream code. This most likely is a issue with below openwrt patch:

https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=package/kernel/mac80211/patches/rt2x00/604-rt2x00-load-eeprom-on-SoC-from-a-mtd-device-defines-.patch;h=a98b49c541f5f76e73751c2fd2e5b85559854b87;hb=HEAD

which for some unknown reason set:

rt2x00dev->eeprom_file = &mtd_fw;

which then crash on rt2x00lib_free_eeprom_file() -> release_firmware();

Regards
Stanislaw
 
