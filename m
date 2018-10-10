Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0028FC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 13:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B94082085B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 13:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GWvwLi/M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XqhwpiWX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B94082085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeJJUdL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 16:33:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbeJJUdL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 16:33:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 17F0960C4D; Wed, 10 Oct 2018 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539177063;
        bh=sU7J+GcygeKi5Q7Z/OcuHjEMF7iPJOQNXp+uC2Uoj9w=;
        h=From:To:Cc:Subject:Date:From;
        b=GWvwLi/MJ822SP+lG+tEDGRMDm+j623IhLVOsfVDZ+60NDaURBVtEnRW4IEdqcCss
         wtJhoTzLjoBJs+nq/shQYOADv7LFr1/iI5kyqRldckOiSJXX3Z4SGL4oRlIQ5u74Xf
         jpiT8kKCFfKwWXHKHdcKYFntqwNLeO5nYO5a2upE=
Received: from x230.qca.qualcomm.com (188-67-121-187.bb.dnainternet.fi [188.67.121.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B98A46063F;
        Wed, 10 Oct 2018 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539177062;
        bh=sU7J+GcygeKi5Q7Z/OcuHjEMF7iPJOQNXp+uC2Uoj9w=;
        h=From:To:Cc:Subject:Date:From;
        b=XqhwpiWX1/1TsIZyApw/1BChcYlsdukeDc3hiWl4l2OxJ96DCz4fLQ2lJ3d5irWBS
         enlokVsOA6WqBU+LJpM1EYoEwN/vo+TWg7FVcLjS51eNVyDht9p2DcyhfwDyfSVFg6
         t/zC0Bbn5i2PfInj+d5vNxQvjYx/R2dx29mmkwnM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B98A46063F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: [PULL] ath10k firmware 2018-10-10
Date:   Wed, 10 Oct 2018 16:10:59 +0300
Message-ID: <87ftxevtek.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi linux-firmware maintainers,

here are ath10k firmware updates which have been accumulating the last 6
months or so. Please let me know if there are any problems.

Kalle

The following changes since commit c6b6265d718d118e28e1ce8f91769aa886b54c94:

  Merge tag 'iwlwifi-fw-2018-10-03' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware (2018-10-08 09:23:53 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git ath10k-20181010

for you to fetch changes up to eaceb79a5a27ef37f85d1a5585b209361330b4bb:

  ath10k: QCA9984 hw1.0: update board-2.bin (2018-10-10 15:14:05 +0300)

----------------------------------------------------------------
Kalle Valo (10):
      ath10k: QCA4019 hw1.0: update firmware-5.bin to 10.4-3.6-00140
      ath10k: QCA4019 hw1.0: update board-2.bin
      ath10k: QCA6174 hw3.0: update firmware-6.bin to RM.4.4.1.c2-00057-QCARMSWP-1
      ath10k: QCA9377 hw1.0: add firmware-6.bin to WLAN.TF.2.1-00021-QCARMSWP-1
      ath10k: QCA9887 hw1.0: update firmware-5.bin to 10.2.4-1.0-00041
      ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.6-00140
      ath10k: QCA9888 hw2.0: update board-2.bin
      ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00041
      ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.6.0.1-00003
      ath10k: QCA9984 hw1.0: update board-2.bin

 WHENCE                                            |   15 +-
 ath10k/QCA4019/hw1.0/board-2.bin                  |  Bin 133452 -> 449316 bytes
 ath10k/QCA4019/hw1.0/firmware-5.bin               |  Bin 568636 -> 583344 bytes
 ath10k/QCA6174/hw3.0/firmware-6.bin               |  Bin 730788 -> 731276 bytes
 ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt |  502 +-------
 ath10k/QCA9377/hw1.0/firmware-6.bin               |  Bin 0 -> 751436 bytes
 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-6.txt | 1352 +++++++++++++++++++++
 ath10k/QCA9887/hw1.0/firmware-5.bin               |  Bin 237584 -> 237660 bytes
 ath10k/QCA9888/hw2.0/board-2.bin                  |  Bin 72788 -> 84928 bytes
 ath10k/QCA9888/hw2.0/firmware-5.bin               |  Bin 659708 -> 675492 bytes
 ath10k/QCA988X/hw2.0/firmware-5.bin               |  Bin 248108 -> 248200 bytes
 ath10k/QCA9984/hw1.0/board-2.bin                  |  Bin 121264 -> 171916 bytes
 ath10k/QCA9984/hw1.0/firmware-5.bin               |  Bin 647380 -> 662084 bytes
 13 files changed, 1423 insertions(+), 446 deletions(-)
 create mode 100644 ath10k/QCA9377/hw1.0/firmware-6.bin
 create mode 100644 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-6.txt
