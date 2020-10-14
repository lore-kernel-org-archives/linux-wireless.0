Return-Path: <SRS0=04kx=DV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1B7C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Oct 2020 03:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628D122227
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Oct 2020 03:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgJND6Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Oct 2020 23:58:24 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:53106 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729395AbgJND6Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Oct 2020 23:58:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 61EF91730847;
        Wed, 14 Oct 2020 03:58:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: pail67_620b2a027208
X-Filterd-Recvd-Size: 3589
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed, 14 Oct 2020 03:58:20 +0000 (UTC)
Message-ID: <73e7098a7dacbbc3a3b77065222f488e23e17201.camel@perches.com>
Subject: iwlwifi: spaces in procfs filenames ?
From:   Joe Perches <joe@perches.com>
To:     Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org
Date:   Tue, 13 Oct 2020 20:58:18 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit 64fa3aff89785b5a924ce3934f6595c35b4dffee
Author: Sharon Dvir <sharon.dvir@intel.com>
Date:   Wed Aug 17 15:35:09 2016 +0300

    iwlwifi: pcie: give a meaningful name to interrupt request

perhaps unintentionally for file:

drivers/net/wireless/intel/iwlwifi/pcie/internal.h
in function static inline const char *queue_name

creates spaces in procfs filenames.

drivers/net/wireless/intel/iwlwifi/pcie/internal.h:static inline const char *queue_name(struct device *dev,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                                  struct iwl_trans_pcie *trans_p, int i)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-{
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (trans_p->shared_vec_mask) {
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             int vec = trans_p->shared_vec_mask &
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                       IWL_SHARED_IRQ_FIRST_RSS ? 1 : 0;
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             if (i == 0)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                     return DRV_NAME ": shared IRQ";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return devm_kasprintf(dev, GFP_KERNEL,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                                   DRV_NAME ": queue %d", i + vec);
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     }
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (i == 0)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return DRV_NAME ": default queue";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     if (i == trans_p->alloc_vecs - 1)
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-             return DRV_NAME ": exception";
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-     return devm_kasprintf(dev, GFP_KERNEL,
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-                           DRV_NAME  ": queue %d", i);
drivers/net/wireless/intel/iwlwifi/pcie/internal.h-}

# find /proc/ | grep " "
/proc/irq/130/iwlwifi: default queue
/proc/irq/131/iwlwifi: queue 1
/proc/irq/132/iwlwifi: queue 2
/proc/irq/133/iwlwifi: queue 3
/proc/irq/134/iwlwifi: queue 4
/proc/irq/135/iwlwifi: exception

Can these names be changed back or collapsed
to avoid the space use in procfs?


