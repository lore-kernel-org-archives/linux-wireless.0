Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CA8C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 06:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4EE5218A1
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 06:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfBFGIm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 01:08:42 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55562 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbfBFGIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 01:08:42 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grGO0-00015m-8C; Wed, 06 Feb 2019 08:08:40 +0200
Message-ID: <1592d4db90b6cee8bc794bcbce06a14fd5226b16.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Jordan Glover <Golden_Miller83@protonmail.ch>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     linuxwifi@intel.com
Date:   Wed, 06 Feb 2019 08:08:39 +0200
In-Reply-To: <CsFdFFRzbpRX_m4C5xfEsE9P5-uv6mNwOUyPl734lLQreQIV9__vxr1NWPkf5oltyFjTZ--34SLql_9ywXamnmw1B7K8lWFzU9kwzWJTdRI=@protonmail.ch>
References: <CsFdFFRzbpRX_m4C5xfEsE9P5-uv6mNwOUyPl734lLQreQIV9__vxr1NWPkf5oltyFjTZ--34SLql_9ywXamnmw1B7K8lWFzU9kwzWJTdRI=@protonmail.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [BUG] Microcode SW error detected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-05 at 14:24 +0000, Jordan Glover wrote:
> Hello,

Hi,


> For a couple of weeks I see following errors printed in
> dmesg from time to time:
> 
> iwlwifi 0000:04:00.0: Queue 4 is active on fifo 1 and stuck for 10000
> ms. SW [189, 201] HW [189, 201] FH TRB=0x0c01040c8
> iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting
> 0x2000000.
> iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
> iwlwifi 0000:04:00.0: Loaded firmware version: 36.9f0a2d68.0
> iwlwifi 0000:04:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
> iwlwifi 0000:04:00.0: 0x200002B0 | trm_hw_status0
> iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
> iwlwifi 0000:04:00.0: 0x0002485C | branchlink2
> iwlwifi 0000:04:00.0: 0x0003A7CA | interruptlink1
> iwlwifi 0000:04:00.0: 0x0003E6A4 | interruptlink2
> iwlwifi 0000:04:00.0: 0x00000000 | data1
> iwlwifi 0000:04:00.0: 0x00000080 | data2
> iwlwifi 0000:04:00.0: 0x07830000 | data3
> iwlwifi 0000:04:00.0: 0x82818D06 | beacon time
> iwlwifi 0000:04:00.0: 0x4E60EC46 | tsf low
> iwlwifi 0000:04:00.0: 0x00000257 | tsf hi
> iwlwifi 0000:04:00.0: 0x00000000 | time gp1
> iwlwifi 0000:04:00.0: 0xBF706F42 | time gp2
> iwlwifi 0000:04:00.0: 0x00000001 | uCode revision type
> iwlwifi 0000:04:00.0: 0x00000024 | uCode version major
> iwlwifi 0000:04:00.0: 0x9F0A2D68 | uCode version minor
> iwlwifi 0000:04:00.0: 0x00000230 | hw version
> iwlwifi 0000:04:00.0: 0x00489000 | board version
> iwlwifi 0000:04:00.0: 0x0000001C | hcmd
> iwlwifi 0000:04:00.0: 0x0222204A | isr0
> iwlwifi 0000:04:00.0: 0x00800000 | isr1
> iwlwifi 0000:04:00.0: 0x0800180A | isr2
> iwlwifi 0000:04:00.0: 0x004000C0 | isr3
> iwlwifi 0000:04:00.0: 0x00000000 | isr4
> iwlwifi 0000:04:00.0: 0xA138009D | last cmd Id
> iwlwifi 0000:04:00.0: 0x00000000 | wait_event
> iwlwifi 0000:04:00.0: 0x00000080 | l2p_control
> iwlwifi 0000:04:00.0: 0x00011420 | l2p_duration
> iwlwifi 0000:04:00.0: 0x0000003F | l2p_mhvalid
> iwlwifi 0000:04:00.0: 0x000000CE | l2p_addr_match
> iwlwifi 0000:04:00.0: 0x0000000D | lmpm_pmg_sel
> iwlwifi 0000:04:00.0: 0x04120134 | timestamp
> iwlwifi 0000:04:00.0: 0x0034B0C8 | flow_handler

This seems to be related to this bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=202397

Can you please comment on that report stating that you are experiencing
the same (or something similar)?

Thanks!

--
Cheers,
Luca.

