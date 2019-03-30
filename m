Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA59CC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 09:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8AD02075E
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 09:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553938322;
	bh=tgEJJsEp8HLK1niWW9oIcWkzJIxjOzFoVIV8bUJ0VlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rZNEzTV7fK5KOKOqKFL2VBOJsQI9l2Sg9jTNj8+55972Pa3ZVPqZNkDwvSHnbEX1t
	 1vN0XPvCeEUNbwfnfKrV+oePFW0jGk4U13WxW62cc6jL9KreH9jUAKL47SlReOzmUj
	 Z1wGphdTi7jTzHfy5tlhraJKAZLMtUafnrh8gRxI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfC3Jb6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 05:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbfC3Jb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 05:31:57 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA4E2075E;
        Sat, 30 Mar 2019 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553938316;
        bh=tgEJJsEp8HLK1niWW9oIcWkzJIxjOzFoVIV8bUJ0VlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NRwgdgKda486H3zPX22uXby3nX7q1xj7baYk1kYymUawG8cEyABTO+iilCzlPTI//
         zzjaqOSVoJDzem209CKzJiORgVgakubh7wysfDYV/ze+n/lYK3MSq0if8jUA10yGeR
         lHv9ukJjMBGtj7HXMNUWG/cG4CI9jFRwjiRU9ltg=
Date:   Sat, 30 Mar 2019 10:31:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] iwlwifi: properly check debugfs dentry before using it
Message-ID: <20190330093152.GB14300@kroah.com>
References: <20190122152151.16139-24-gregkh@linuxfoundation.org>
 <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
 <20190327012600.GA3649@kroah.com>
 <5660d50d-6cbf-3b36-6e6c-312b1617ed23@redhat.com>
 <20190327015346.GA17979@kroah.com>
 <5f9c8beda0e925b079aa9342ce1c9523659837a4.camel@coelho.fi>
 <20190330092247.GA14300@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330092247.GA14300@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

debugfs can now report an error code if something went wrong instead of
just NULL.  So if the return value is to be used as a "real" dentry, it
needs to be checked if it is an error before dereferencing it.

This is now happening because of ff9fb72bc077 ("debugfs: return error
values, not NULL").  If multiple iwlwifi devices are in the system, this
can cause problems when the driver attempts to create the main debugfs
directory again.  Later on in the code we fail horribly by trying to
dereference a pointer that is an error value.

Reported-by: Laura Abbott <labbott@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: stable <stable@vger.kernel.org> # 5.0
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 2453ceabf00d..6925527d8457 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -774,8 +774,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
-
-	if (!mvmvif->dbgfs_dir) {
+	if (IS_ERR_OR_NULL(mvmvif->dbgfs_dir)) {
 		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
 			dbgfs_dir);
 		return;
