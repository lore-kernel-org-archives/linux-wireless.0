Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF93C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B2B21473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iFU4fL7k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cnWDvpDF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66B2B21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeJDSh1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 14:37:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbeJDSh1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 14:37:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 238D460C88; Thu,  4 Oct 2018 11:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538653474;
        bh=QCWhNhYzvqk9WCN/hhJ/CJ7czogV3C0+0u01oTn/9Mc=;
        h=From:To:Cc:Subject:Date:From;
        b=iFU4fL7kXGBkASiHEvKM8W2szvRukXdfpib2Bof6rTk7O2Rv8aBoh8oFbn0c+Mb5Z
         phDGCIBCVu4smNBQ5CEej9hynoHCQafpiUh4SqlynFKPJLg8IQm7aSaX/Vkodu39rd
         Y8qg/GBfYvfYDVNQ8xBP43eAXlzMMQMXGP3w3HvA=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D582860C62;
        Thu,  4 Oct 2018 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538653473;
        bh=QCWhNhYzvqk9WCN/hhJ/CJ7czogV3C0+0u01oTn/9Mc=;
        h=From:To:Cc:Subject:Date:From;
        b=cnWDvpDFrxc6v1jqtQT8siia5KD8X4O+LE2R2iArygyV3G0NYwEt8uyNa++uKXNDa
         Suylrt2XRtCyX30at0TCnnftQ0gs8yuBBlZIoN6M0cvlONy3zOliVuXFbC/xH8Z8If
         UX4ekSIC4dPIu+iHjN2gocU9yqLkyLYKnMriGtjY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D582860C62
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        bperumal@codeaurora.org
Subject: [PATCH 0/2] ath10k: Add support to configure BB timing for external FEM
Date:   Thu,  4 Oct 2018 17:12:42 +0530
Message-Id: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds support to choose correct Base Band(BB) timing values based on
the input Front End Module(FEM) hardware name from Device Tree entry and
configure it in hardware through WMI interface. Since the BB timing values
can vary between FEM hardwares and not same as default value used
in reference hardware.

Bhagavathi Perumal S (2):
  dt: bindings: add new dt entry to indentify external FEM
  ath10k: Add support to configure BB timing over wmi

 .../bindings/net/wireless/qcom,ath10k.txt          | 22 ++++++++++
 drivers/net/wireless/ath/ath10k/mac.c              | 47 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h          | 20 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c              | 23 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h              | 26 ++++++++++++
 5 files changed, 138 insertions(+)

-- 
1.9.1

