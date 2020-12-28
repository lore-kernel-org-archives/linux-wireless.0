Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7431C43331
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 11:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C79622573
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Dec 2020 11:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgL1L64 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Dec 2020 06:58:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:33042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbgL1L64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Dec 2020 06:58:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DD8C9AF61;
        Mon, 28 Dec 2020 11:58:14 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 965D1603A8; Mon, 28 Dec 2020 12:58:14 +0100 (CET)
Date:   Mon, 28 Dec 2020 12:58:14 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Arjen de Korte <suse+build@de-korte.org>
Subject: regression in iwlwifi: page fault in iwl_dbg_tlv_alloc_region()
 (commit ba8f6f4ae254)
Message-ID: <20201228115814.GA5880@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

FYI, there is a regression in iwlwifi driver caused by commit
ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")
reported at

  https://bugzilla.kernel.org/show_bug.cgi?id=210733
  https://bugzilla.suse.com/show_bug.cgi?id=1180344

The problem seems to be an attempt to write terminating null character
into a string which may be read only. There is also a proposed fix.

Michal
