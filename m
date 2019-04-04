Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E794DC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB4320855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 10:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hAsSnoIS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wc5JdQvW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfDDKL3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:11:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36588 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDDKL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 06:11:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ECACC6178C; Thu,  4 Apr 2019 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372687;
        bh=qEfnld3susTzPDK4Oc32FjsXVPey8uVZyqrtDyH2HFE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hAsSnoIS5W2syJHhXwutq84fTSAS9XV/CHvDn26ZMBKF1dIRim2c7RF6VDNZtS6AN
         UVaHtFeapbGAf9mMtqe0/dNok1NfmegpjPYo3vLrGQGHlGwONxmxoCqnsu/8lk743D
         T7lJWgUWYRPet2mvcw84DzFUgteV/gBM8EeltmvM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CAA4F613A3;
        Thu,  4 Apr 2019 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554372683;
        bh=qEfnld3susTzPDK4Oc32FjsXVPey8uVZyqrtDyH2HFE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Wc5JdQvWlJ5ZZgk3sPW35htVLaXn2Zc95gEgkaii+TSCwKgdtZ4h3s7lSis6WeqFq
         N3NPGdytxlAZ5DYrlOMB48dbKjpfAozojB5yUJ0cznQCA4O57cVxZjOePpv/W5XuUc
         XmCp99qeA4xm8PZSaAV5BqEL9Dp9ccu4x4i68kEs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CAA4F613A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] brcmfmac: fix race during disconnect when USB
 completion is in progress
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1552058658-23250-2-git-send-email-p.figiel@camlintechnologies.com>
References: <1552058658-23250-2-git-send-email-p.figiel@camlintechnologies.com>
To:     Piotr Figiel <p.figiel@camlintechnologies.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Pawel Lenkow <p.lenkow@camlintechnologies.com>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        =?iso-8859-2?q?Krzysztof_D?==?iso-8859-2?q?robi=F1ski?= 
        <k.drobinski@camlintechnologies.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190404101126.ECACC6178C@smtp.codeaurora.org>
Date:   Thu,  4 Apr 2019 10:11:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Piotr Figiel <p.figiel@camlintechnologies.com> wrote:

> It was observed that rarely during USB disconnect happening shortly after
> connect (before full initialization completes) usb_hub_wq would wait
> forever for the dev_init_lock to be unlocked. dev_init_lock would remain
> locked though because of infinite wait during usb_kill_urb:
> 
> [ 2730.656472] kworker/0:2     D    0   260      2 0x00000000
> [ 2730.660700] Workqueue: events request_firmware_work_func
> [ 2730.664807] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0xac)
> [ 2730.670587] [<809dd164>] (schedule) from [<8069af44>] (usb_kill_urb+0xdc/0x114)
> [ 2730.676815] [<8069af44>] (usb_kill_urb) from [<7f258b50>] (brcmf_usb_free_q+0x34/0xa8 [brcmfmac])
> [ 2730.684833] [<7f258b50>] (brcmf_usb_free_q [brcmfmac]) from [<7f2517d4>] (brcmf_detach+0xa0/0xb8 [brcmfmac])
> [ 2730.693557] [<7f2517d4>] (brcmf_detach [brcmfmac]) from [<7f251a34>] (brcmf_attach+0xac/0x3d8 [brcmfmac])
> [ 2730.702094] [<7f251a34>] (brcmf_attach [brcmfmac]) from [<7f2587ac>] (brcmf_usb_probe_phase2+0x468/0x4a0 [brcmfmac])
> [ 2730.711601] [<7f2587ac>] (brcmf_usb_probe_phase2 [brcmfmac]) from [<7f252888>] (brcmf_fw_request_done+0x194/0x220 [brcmfmac])
> [ 2730.721795] [<7f252888>] (brcmf_fw_request_done [brcmfmac]) from [<805748e4>] (request_firmware_work_func+0x4c/0x88)
> [ 2730.731125] [<805748e4>] (request_firmware_work_func) from [<80141474>] (process_one_work+0x228/0x808)
> [ 2730.739223] [<80141474>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
> [ 2730.746105] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
> [ 2730.752227] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
> 
> [ 2733.099695] kworker/0:3     D    0  1065      2 0x00000000
> [ 2733.103926] Workqueue: usb_hub_wq hub_event
> [ 2733.106914] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0xac)
> [ 2733.112693] [<809dd164>] (schedule) from [<809e2a8c>] (schedule_timeout+0x214/0x3e4)
> [ 2733.119621] [<809e2a8c>] (schedule_timeout) from [<809dde2c>] (wait_for_common+0xc4/0x1c0)
> [ 2733.126810] [<809dde2c>] (wait_for_common) from [<7f258d00>] (brcmf_usb_disconnect+0x1c/0x4c [brcmfmac])
> [ 2733.135206] [<7f258d00>] (brcmf_usb_disconnect [brcmfmac]) from [<8069e0c8>] (usb_unbind_interface+0x5c/0x1e4)
> [ 2733.143943] [<8069e0c8>] (usb_unbind_interface) from [<8056d3e8>] (device_release_driver_internal+0x164/0x1fc)
> [ 2733.152769] [<8056d3e8>] (device_release_driver_internal) from [<8056c078>] (bus_remove_device+0xd0/0xfc)
> [ 2733.161138] [<8056c078>] (bus_remove_device) from [<8056977c>] (device_del+0x11c/0x310)
> [ 2733.167939] [<8056977c>] (device_del) from [<8069cba8>] (usb_disable_device+0xa0/0x1cc)
> [ 2733.174743] [<8069cba8>] (usb_disable_device) from [<8069507c>] (usb_disconnect+0x74/0x1dc)
> [ 2733.181823] [<8069507c>] (usb_disconnect) from [<80695e88>] (hub_event+0x478/0xf88)
> [ 2733.188278] [<80695e88>] (hub_event) from [<80141474>] (process_one_work+0x228/0x808)
> [ 2733.194905] [<80141474>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
> [ 2733.201724] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
> [ 2733.207913] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
> 
> It was traced down to a case where usb_kill_urb would be called on an URB
> structure containing more or less random data, including large number in
> its use_count. During the debugging it appeared that in brcmf_usb_free_q()
> the traversal over URBs' lists is not synchronized with operations on those
> lists in brcmf_usb_rx_complete() leading to handling
> brcmf_usbdev_info structure (holding lists' head) as lists' element and in
> result causing above problem.
> 
> Fix it by walking through all URBs during brcmf_cancel_all_urbs using the
> arrays of requests instead of linked lists.
> 
> Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>

3 patches applied to wireless-drivers-next.git, thanks.

db3b9e2e1d58 brcmfmac: fix race during disconnect when USB completion is in progress
2b78e5f52236 brcmfmac: remove pending parameter from brcmf_usb_free_q
504f06725d01 brcmfmac: remove unused variable i from brcmf_usb_free_q

-- 
https://patchwork.kernel.org/patch/10845051/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

