Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C45C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFCC20855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W+wNP02i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WRsomBdU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfDDKKq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:10:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfDDKKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:10:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65B7261B1C; Thu,  4 Apr 2019 10:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372644;
        bh=ATCxbiV4ZfmrT4DNFeETAW23D+aQDvpRzxMrkolOcc8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W+wNP02ilWz/tFUjxGXCZvuixeAm8aqspMbYB9OD6IS17cAxto1iX7NGor80UtBrl
         GM3P6c5voWwtaERzuCJxLYveNm7+8hZ2si97dMnESVL5K4nyJ8jr6f4GD4D1QzUhiA
         R5VUwcNsZUQcgkDsuRJ+VC7EzbiUHmrCwaytj0SE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCE2961785;
        Thu,  4 Apr 2019 10:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372641;
        bh=ATCxbiV4ZfmrT4DNFeETAW23D+aQDvpRzxMrkolOcc8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WRsomBdUWPmaMhdIr7q90dnmvChm3Yp/jsr1tpK1XVCbK0L0BiqKEef7HXMDDvsJN
         M8r7jirrN9XMua9S3Cvy0yyzPFGB1lWK8tQRcGWkhjSPfTUbpaY3s71ez/c728F9bB
         q/lTIplYvCRmIRrXequRLNyGkB5jds57XC2xpBL0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCE2961785
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] brcmfmac: fix WARNING during USB disconnect in case
 of unempty psq
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1551714128-27412-2-git-send-email-p.figiel@camlintechnologies.com>
References: <1551714128-27412-2-git-send-email-p.figiel@camlintechnologies.com>
To:     Piotr Figiel <p.figiel@camlintechnologies.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101044.65B7261B1C@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:10:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Piotr Figiel <p.figiel@camlintechnologies.com> wrote:

> brcmu_pkt_buf_free_skb emits WARNING when attempting to free a sk_buff
> which is part of any queue. After USB disconnect this may have happened
> when brcmf_fws_hanger_cleanup() is called as per-interface psq was never
> cleaned when removing the interface.
> Change brcmf_fws_macdesc_cleanup() in a way that it removes the
> corresponding packets from hanger table (to avoid double-free when
> brcmf_fws_hanger_cleanup() is called) and add a call to clean-up the
> interface specific packet queue.
> 
> Below is a WARNING during USB disconnect with Raspberry Pi WiFi dongle
> running in AP mode. This was reproducible when the interface was
> transmitting during the disconnect and is fixed with this commit.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1171 at drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c:49 brcmu_pkt_buf_free_skb+0x3c/0x40
> Modules linked in: nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_mangle xt_connmark xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tables usb_f_mass_storage usb_f_rndis u_ether cdc_acm smsc95xx usbnet ci_hdrc_imx ci_hdrc ulpi usbmisc_imx 8250_exar 8250_pci 8250 8250_base libcomposite configfs udc_core
> CPU: 0 PID: 1171 Comm: kworker/0:0 Not tainted 4.19.23-00075-gde33ed8 #99
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: usb_hub_wq hub_event
> [<8010ff84>] (unwind_backtrace) from [<8010bb64>] (show_stack+0x10/0x14)
> [<8010bb64>] (show_stack) from [<80840278>] (dump_stack+0x88/0x9c)
> [<80840278>] (dump_stack) from [<8011f5ec>] (__warn+0xfc/0x114)
> [<8011f5ec>] (__warn) from [<8011f71c>] (warn_slowpath_null+0x40/0x48)
> [<8011f71c>] (warn_slowpath_null) from [<805a476c>] (brcmu_pkt_buf_free_skb+0x3c/0x40)
> [<805a476c>] (brcmu_pkt_buf_free_skb) from [<805bb6c4>] (brcmf_fws_cleanup+0x1e4/0x22c)
> [<805bb6c4>] (brcmf_fws_cleanup) from [<805bc854>] (brcmf_fws_del_interface+0x58/0x68)
> [<805bc854>] (brcmf_fws_del_interface) from [<805b66ac>] (brcmf_remove_interface+0x40/0x150)
> [<805b66ac>] (brcmf_remove_interface) from [<805b6870>] (brcmf_detach+0x6c/0xb0)
> [<805b6870>] (brcmf_detach) from [<805bdbb8>] (brcmf_usb_disconnect+0x30/0x4c)
> [<805bdbb8>] (brcmf_usb_disconnect) from [<805e5d64>] (usb_unbind_interface+0x5c/0x1e0)
> [<805e5d64>] (usb_unbind_interface) from [<804aab10>] (device_release_driver_internal+0x154/0x1ec)
> [<804aab10>] (device_release_driver_internal) from [<804a97f4>] (bus_remove_device+0xcc/0xf8)
> [<804a97f4>] (bus_remove_device) from [<804a6fc0>] (device_del+0x118/0x308)
> [<804a6fc0>] (device_del) from [<805e488c>] (usb_disable_device+0xa0/0x1c8)
> [<805e488c>] (usb_disable_device) from [<805dcf98>] (usb_disconnect+0x70/0x1d8)
> [<805dcf98>] (usb_disconnect) from [<805ddd84>] (hub_event+0x464/0xf50)
> [<805ddd84>] (hub_event) from [<80135a70>] (process_one_work+0x138/0x3f8)
> [<80135a70>] (process_one_work) from [<80135d5c>] (worker_thread+0x2c/0x554)
> [<80135d5c>] (worker_thread) from [<8013b1a0>] (kthread+0x124/0x154)
> [<8013b1a0>] (kthread) from [<801010e8>] (ret_from_fork+0x14/0x2c)
> Exception stack(0xecf8dfb0 to 0xecf8dff8)
> dfa0:                                     00000000 00000000 00000000 00000000
> dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> ---[ end trace 38d234018e9e2a90 ]---
> ------------[ cut here ]------------
> 
> Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>

2 patches applied to wireless-drivers-next.git, thanks.

c80d26e81ef1 brcmfmac: fix WARNING during USB disconnect in case of unempty psq
5cdb0ef6144f brcmfmac: fix NULL pointer derefence during USB disconnect

-- 
https://patchwork.kernel.org/patch/10837981/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

