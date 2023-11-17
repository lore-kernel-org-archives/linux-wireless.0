Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C27C54FB9
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Nov 2023 22:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbjKQWss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Nov 2023 17:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjKQWsr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2023 17:48:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89514194;
        Fri, 17 Nov 2023 14:48:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA79AC433C7;
        Fri, 17 Nov 2023 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700261324;
        bh=G4NOVs4MQraA/nBl5omLYKNn4/g0XJx+3HT14eCrK5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MpWTT+oXOcmEqjeT46xKYTYDq1bx/VN+pHBLL6e/kyqWeXNGbAiOpdHBsvLW1LDhn
         rR0gx0pSqwhiRH/C68jpnOSN499p6HMnOlqw3G4HTMy4FBdgdV6LmOAfyoYpbF3nes
         mr7c9NtuqkYYK6IkZGnrVoKNVSglQA9xoYQlrgCU/UC309kiVCmtXgNQIKw/2oAjvB
         RQDCkmhNBHaMC5dlJuUIapojGzf/PuACTc4sMsqnxClcIcxeLxPdRrzIIHj7wgKjye
         IF/ag2AwwTTXGQ0mP0fX6+4BtbuN384lZy92bAtyDaNPXWnIDpe61HfZ5r8xjuOwf7
         D6WrIdxro0/3A==
Date:   Fri, 17 Nov 2023 16:48:42 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] rtlwifi: rtl8821ae: Access full PMCS reg and use
 pci_regs.h
Message-ID: <20231117224842.GA96270@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231117094425.80477-8-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 17, 2023 at 11:44:25AM +0200, Ilpo Järvinen wrote:
> _rtl8821ae_clear_pci_pme_status() accesses the upper byte of the Power
> Management Control/Status register (PMCS) with literal 5 offset.
> 
> Access the entire PMCS register using defines from pci_regs.h to
> improve code readability.
> 
> While at it, remove the obvious comment and tweak debug prints
> slightly to not sound misleading.

OK, ignore my previous comments ;)  I should read all the way through
before responding.
