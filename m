Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFC4C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 07:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D8B207E8
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 07:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593157283;
	bh=qieK7Lo35Y3bAJaWF45h/K/UGXA4Ll99IwBAmdtK4b4=;
	h=Date:From:To:Subject:List-ID:From;
	b=pA2cNlKXEELDcLUwXy4BqFIsHK+qZwNP10u2Ikg9oYd7TjwE76ptjVDMsAaQoM0lJ
	 aISqPdtmrKw2ocn4NPBLHk6jCTnYOpN90hbaFg+4DC/bl0R7jrscacOhE0s1bhqEep
	 db9K8pcuMGsH4i/nQIc3eAWhu0uH/FIgGowngn08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgFZHlW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 03:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFZHlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 03:41:22 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A0B20775;
        Fri, 26 Jun 2020 07:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593157282;
        bh=qieK7Lo35Y3bAJaWF45h/K/UGXA4Ll99IwBAmdtK4b4=;
        h=Date:From:To:Subject:From;
        b=AZfg/qOo81fgndZUzriJoRwVTnvB7uYoMvLdeeVmAoepAVzoLlH0j1TOJrGTBogiU
         IcrxQ/lggxUD214l2J/sI2aUqsLkWyr742scbgxNcsLjAk4tviGzLPYXU0dqzo4Ymj
         4rl6pU68tjA/d1U8tWTwqK+FEHawd+qacZiMKbvw=
Received: by pali.im (Postfix)
        id B7410890; Fri, 26 Jun 2020 09:41:19 +0200 (CEST)
Date:   Fri, 26 Jun 2020 09:41:19 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: ath10k_pci spams dmesg "failed to send pdev bss chan info request"
Message-ID: <20200626074119.2aonlyfqb3ve65p3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello!

During testing 5.8.0-rc2 kernel version with Compex WLE900VX card
(ath10k) I see following error in dmesg which is periodically repeating,
sometimes every second:

ath10k_pci 0000:01:00.0: failed to send pdev bss chan info request

Card has firmware version 10.1 and features wmi-10.x,has-wmi-mgmt-tx,mfp

That error message is located in file ath10k/mac.c in the function
ath10k_mac_update_bss_chan_survey().

I checked that 'ret' variable in that function contains value -95 which
is -EOPNOTSUPP. It seems that ath10k_wmi_pdev_bss_chan_info_request() is
not really supported by firmware 10.1.

That function is used only by ath10k_get_survey() function and
ath10k_get_survey() ignores all errors from the function
ath10k_mac_update_bss_chan_survey(). Which seems wrong as get_survey()
could return -EOPNOTSUPP when it is not supported.

Could we at least skip printing that error message when 'ret' is
-EOPNOTSUPP?
