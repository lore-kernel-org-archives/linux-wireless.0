Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE6AC433FE
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Feb 2022 19:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbiBJTUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Feb 2022 14:20:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343881AbiBJTUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Feb 2022 14:20:20 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D08B4A
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2022 11:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=QYRcPtnXIElo5tCvWZVYgDABCp3wLDJymDE/X0UX64M=; t=1644520820; x=1645730420; 
        b=t+lbzdWmsSDf+Ote95RLzlDcyAXXdh8x3Qsfb1OInnwohZPVRK+iM5g6ybGYtU8ZDoF6vgh9qOV
        f3H7aGHV7G6XQUAmAD2OQXhpd6X36fLANMxfKwQmmBu4dtccFfQRbEDDwR/dZq24wS13PCI6nwEvC
        Uq4DMyFZOxDcrnOq1KP89eRnPxJ0G1WY7V6imTf8QDmB8MoJhyeMqapffTwAjzk0Xy76wr8xrZROR
        0T1cO880DulcaauTYOCxrbypusirurPdMlwIujL07phCDzveS5WIn2XRxKAhjzFnnOi/iyWE+z0Q/
        CjI+TzGAWLlZevSsryAK7UXqdz+EpAZ9Ut8g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nIEzJ-00HC2X-7v;
        Thu, 10 Feb 2022 20:20:17 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     quic_vikram@quicinc.com, quic_alokad@quicinc.com,
        quic_jiad@quicinc.com, quic_periyasa@quicinc.com,
        quic_msinada@quicinc.com, quic_srirrama@quicinc.com,
        ilan.peer@intel.com
Subject: [PATCH v2 00/19] initial EHT support
Date:   Thu, 10 Feb 2022 20:19:49 +0100
Message-Id: <20220210192008.188166-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This has many changes, among them:

 - fixes for things commented out
 - moved to D1.4
 - added more validation/checks etc. like the HE series I sent

Since the draft is still evolving, IMHO we should merge this and
have a common base to work on - but especially the EHT operation
element is not defined well right now.

johannes


