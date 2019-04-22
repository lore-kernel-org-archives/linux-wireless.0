Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7A2C10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 18:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACAB20B1F
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555956452;
	bh=xDMrJudM/8E8/MqVWSOMMEKSIAJOcYcvK7lhk4bh/4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jgf8PevJCtOmttwemFVdxQPf7D+9SvN8NUd9u1nCCgkqEcFYXfOH5CuhgTWyyIEQq
	 DkBGuv06U7ejI1bQDyA1os035S+4XZf42RBRHoNcBB38VNv3xvesuH3xbbT/DyeT8o
	 WJXde/d6v3+2R57uFNeMMveShc53yICqLJSiEK0A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfDVSH1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 14:07:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:37252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727279AbfDVSH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 14:07:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B462AAEFD;
        Mon, 22 Apr 2019 18:07:24 +0000 (UTC)
Date:   Mon, 22 Apr 2019 20:07:23 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Message-ID: <20190422180723.GA20259@dhcp22.suse.cz>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
 <20190417073516.24250-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417073516.24250-1-luca@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed 17-04-19 10:35:16, Luca Coelho wrote:
> From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> 
> The driver uses msix causes-register to handle both msix and non msix
> interrupts when performing sync nmi.  On devices that do not support
> msix this register is unmapped and accessing it causes a kernel panic.
> 
> Solve this by differentiating the two cases and accessing the proper
> causes-register in each case.
> 
> Reported-by: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

$ dmesg | grep "Error sending SCAN_CFG_CMD:"
[49786.288548] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
[53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.

without the oops and with the iwlwifi internal dump IIUC which is the
previous behavior.
[53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
[53457.166882] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 224 write_ptr 225
[53457.414973] iwlwifi 0000:01:00.0: HW error, resetting before reading
[53457.421339] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[53457.421345] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1269232956
[53457.421347] iwlwifi 0000:01:00.0: Loaded firmware version: 36.9f0a2d68.0
[53457.421350] iwlwifi 0000:01:00.0: 0x45E91306 | ADVANCED_SYSASSERT          
[53457.421352] iwlwifi 0000:01:00.0: 0x2F58D384 | trm_hw_status0
[53457.421353] iwlwifi 0000:01:00.0: 0x7F1A8CFD | trm_hw_status1
[53457.421355] iwlwifi 0000:01:00.0: 0x07E787FD | branchlink2
[53457.421357] iwlwifi 0000:01:00.0: 0xE9E54368 | interruptlink1
[53457.421359] iwlwifi 0000:01:00.0: 0x470D9BBF | interruptlink2
[53457.421361] iwlwifi 0000:01:00.0: 0xAF040E7E | data1
[53457.421362] iwlwifi 0000:01:00.0: 0xE7FBCA48 | data2
[53457.421364] iwlwifi 0000:01:00.0: 0x4E4A8288 | data3
[53457.421366] iwlwifi 0000:01:00.0: 0x861DEA98 | beacon time
[53457.421368] iwlwifi 0000:01:00.0: 0xE8F23466 | tsf low
[53457.421369] iwlwifi 0000:01:00.0: 0xD7B19307 | tsf hi
[53457.421371] iwlwifi 0000:01:00.0: 0xE58934E3 | time gp1
[53457.421373] iwlwifi 0000:01:00.0: 0xB013FEBE | time gp2
[53457.421375] iwlwifi 0000:01:00.0: 0x962DCC75 | uCode revision type
[53457.421376] iwlwifi 0000:01:00.0: 0xFF8FB30F | uCode version major
[53457.421378] iwlwifi 0000:01:00.0: 0x0DD08E17 | uCode version minor
[53457.421380] iwlwifi 0000:01:00.0: 0x87FD70DE | hw version
[53457.421382] iwlwifi 0000:01:00.0: 0x853F6851 | board version
[53457.421384] iwlwifi 0000:01:00.0: 0x08D7F330 | hcmd
[53457.421385] iwlwifi 0000:01:00.0: 0x6B7E5FEE | isr0
[53457.421387] iwlwifi 0000:01:00.0: 0x2B1E7CD4 | isr1
[53457.421389] iwlwifi 0000:01:00.0: 0x3F133B16 | isr2
[53457.421391] iwlwifi 0000:01:00.0: 0x5D480C5A | isr3
[53457.421392] iwlwifi 0000:01:00.0: 0x34E93EBA | isr4
[53457.421394] iwlwifi 0000:01:00.0: 0x42AD8E83 | last cmd Id
[53457.421396] iwlwifi 0000:01:00.0: 0x1F5BBCFF | wait_event
[53457.421398] iwlwifi 0000:01:00.0: 0x6808B2C1 | l2p_control
[53457.421399] iwlwifi 0000:01:00.0: 0x0D5B1F33 | l2p_duration
[53457.421401] iwlwifi 0000:01:00.0: 0xF4C94535 | l2p_mhvalid
[53457.421403] iwlwifi 0000:01:00.0: 0x3DCE6EBB | l2p_addr_match
[53457.421405] iwlwifi 0000:01:00.0: 0xFDDC41FE | lmpm_pmg_sel
[53457.421406] iwlwifi 0000:01:00.0: 0xB53A17F5 | timestamp
[53457.421408] iwlwifi 0000:01:00.0: 0x5A6A4113 | flow_handler
[53457.421474] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[53457.421477] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1182976748
[53457.421478] iwlwifi 0000:01:00.0: 0x62D2BDB3 | ADVANCED_SYSASSERT
[53457.421480] iwlwifi 0000:01:00.0: 0x4D9E5019 | umac branchlink1
[53457.421482] iwlwifi 0000:01:00.0: 0x8CB69F6E | umac branchlink2
[53457.421484] iwlwifi 0000:01:00.0: 0x9868662D | umac interruptlink1
[53457.421486] iwlwifi 0000:01:00.0: 0x9800F8F7 | umac interruptlink2
[53457.421488] iwlwifi 0000:01:00.0: 0xC71449B8 | umac data1
[53457.421489] iwlwifi 0000:01:00.0: 0xAB0AB17F | umac data2
[53457.421491] iwlwifi 0000:01:00.0: 0x6C6F9753 | umac data3
[53457.421493] iwlwifi 0000:01:00.0: 0xFC49D724 | umac major
[53457.421495] iwlwifi 0000:01:00.0: 0xA61CC627 | umac minor
[53457.421496] iwlwifi 0000:01:00.0: 0x45BAA0B8 | frame pointer
[53457.421498] iwlwifi 0000:01:00.0: 0x319D112B | stack pointer
[53457.421500] iwlwifi 0000:01:00.0: 0xEFD9E2E9 | last host cmd
[53457.421502] iwlwifi 0000:01:00.0: 0x82640FF7 | isr status reg
[53457.421506] ieee80211 phy0: Hardware restart was requested
[53457.941685] iwlwifi 0000:01:00.0: Queue 0 is inactive on fifo 0 and stuck for 2500 ms. SW [224, 225] HW [0, 0] FH TRB=0x02b759ca1

Feel free to add
Tested-by: Michal Hocko <mhocko@suse.com>

Thanks for your quick patch and sorry it took so long from my side.

-- 
Michal Hocko
SUSE Labs
