Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A617C8301A
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Nov 2020 13:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D552821D40
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Nov 2020 13:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fxFvY4F9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbgKZNcH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390188AbgKZNcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Nov 2020 08:32:06 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F7C061A47
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2020 05:32:06 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id l1so2153823wrb.9
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2020 05:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=fxFvY4F9TAI3WLouXVEDBCny/tfmKyGzUcAMYh+tZX60mwEb575ArQEYNr1as6rviJ
         b5iYC89cQ3hyCFHG7ZaehdrRYgrT6ouRF4gJ/jYIk3lXhlIIACIwxcmua1P/3CsedSTX
         m5mf8HS4rAwHshbiXkaE4dvZ8a1vJFTTjhOSJ5nijQendWJ/7lJ6iPOwW69wsFOBFNW8
         rlsQlL5M1yPZwp+hIOslJDuJbVqYnwliaVqpCIZa6SI/9IV0Fa8qIe8e5pdUOMWbTUTX
         1WOUoyCBbAZVcYxGie+kvw7PT0Ww8qc5rLjAS/1ykNx13GP7OOognTQk8j08i8iPRcfO
         7d2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=ThWuXSpnietYqz1rJ2LZfTC3V8dbgyLN8kHWYhsvJAW42f3Os2JZznantE5qfINSp1
         FOs2eCRUkRlW9NM5gb237iMqmB/HlDiBajyXU+garTMyxit6mfuh4lGl4hSWrS2CB+cJ
         WVGRyNsnoxmIChIGRvxm5MDgwKPFMsr0wEhefezbvW3E8zDE7zozxZFNvcEQyPy4/3a1
         eH0DmRpY/DsLT6pop4otn3avLQwBMCymHJJRypnUvRUeQTs0spid1p7JnKGakrZNqMFA
         ULujEnyoRbF3nR20wu8CIBptuqqRN8Nl1WDcGaUE+yCo+Q8mvQNXCdWs+72TOhYsdL9L
         uXmA==
X-Gm-Message-State: AOAM533zL0fYTd4ydGqQjfWxmQ/UR0gx8Yrk7XDNt8tM8MoIww9dPdzF
        eXCSC8QTd0RKdl+gm/LNeB/9BQ==
X-Google-Smtp-Source: ABdhPJxEqrNkgHGQvyOLo0FR6NpjjkFky++1qbEa/oplWQmxA4TLp1X2l26V0s1OnHiEeUtF4gnwCw==
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr3797328wrx.331.1606397524835;
        Thu, 26 Nov 2020 05:32:04 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/17] iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
Date:   Thu, 26 Nov 2020 13:31:42 +0000
Message-Id: <20201126133152.3211309-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'trans' not described in 'iwl_read_eeprom'
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'eeprom' not described in 'iwl_read_eeprom'
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'eeprom_size' not described in 'iwl_read_eeprom'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
index ad6dc4497437e..1b2d9fd82a3de 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
@@ -335,7 +335,7 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
 	return -EINVAL;
 }
 
-/**
+/*
  * iwl_read_eeprom - read EEPROM contents
  *
  * Load the EEPROM contents from adapter and return it
-- 
2.25.1

