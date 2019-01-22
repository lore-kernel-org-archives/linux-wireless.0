Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73699C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B34F20870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfAVOVO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:21:14 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36647 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfAVOVO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 09:21:14 -0500
Received: by mail-ed1-f68.google.com with SMTP id f23so19445783edb.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 06:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bjkmQPAuLyx/OjBzqxICP15YyBMZHw2bg5N5CtLnEFk=;
        b=YgrQHmy0+wDYy2LwHRme+zWr7ifS6qT6oL87YiEHYdsPzfhuYtjU32lvCdI/QKaHqe
         ol4qxFusvVIXl8H0rM8swvQAjZQswQIFsTDOK22KvOt1tXl8Ewwu+HmtrMR5bqmN/wbr
         4bKpVzICAy5ZEWAxobHQet8TKmMtDyfJfMBbhDXzJHmRIfBciphSKuCdCd509+DTw8gx
         s97PI4g9Qa65tKGaCZxpMBipDEVE+3UEUqAJyv4d/Q9Mew0Ng1UOZJ+BI567KBS4dzVz
         9hf0FcyQa5q5fH3vzTXdEduRBjZCMtngWFu/0GzbgZm16VKJ7bwXiX9mTV+hbDiv4ybJ
         9uWA==
X-Gm-Message-State: AJcUukcXtRUSK5H/ooRPpA8xQ8yCRzat0HpTDQMAtBIcsPBRp/Tz1Zt4
        E9sCAPRZwKvvDQmaNOPdp5X8NA==
X-Google-Smtp-Source: ALg8bN4RjEEDlqTjTJ2dG1HTjEDaWAr9w2BgWT/S7xXQoor7/mxqGfy3xlBSnfeYu9eU58Z3gjkZxg==
X-Received: by 2002:a17:906:b303:: with SMTP id n3-v6mr28736188ejz.34.1548166872545;
        Tue, 22 Jan 2019 06:21:12 -0800 (PST)
Received: from tohojo-x1-rh.localdomain (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id k32sm9850741edb.42.2019.01.22.06.21.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 06:21:11 -0800 (PST)
Received: by tohojo-x1-rh.localdomain (Postfix, from userid 1000)
        id 332F51833C1; Tue, 22 Jan 2019 15:21:10 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Subject: [PATCH v6 0/4] Switch ath9k and ath10k to mac80211 airtime framework
Date:   Tue, 22 Jan 2019 15:20:15 +0100
Message-Id: <20190122142019.21417-1-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an updated resend of the driver part of the previous patch set
that moves airtime fairness scheduling into mac80211 and enables it for
ath10k as well.

This version is just a refresh of the driver code, along with a small
fix for the issue I noticed yesterday where ath9k was calling
ieee80211_return_txq() without proper logging.


Kan Yan (1):
  ath10k: reporting estimated tx airtime for fairness

Toke Høiland-Jørgensen (3):
  mac80211: Expose ieee80211_schedule_txq() function
  ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
  ath10k: migrate to mac80211 txq scheduling

 drivers/net/wireless/ath/ath10k/core.c     |   2 -
 drivers/net/wireless/ath/ath10k/core.h     |   8 +-
 drivers/net/wireless/ath/ath10k/htc.h      |   1 -
 drivers/net/wireless/ath/ath10k/htt_rx.c   |   9 +
 drivers/net/wireless/ath/ath10k/mac.c      | 155 ++++++++-----
 drivers/net/wireless/ath/ath10k/txrx.c     |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h     |  14 --
 drivers/net/wireless/ath/ath9k/debug.c     |   3 -
 drivers/net/wireless/ath/ath9k/debug.h     |   8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c |  70 ------
 drivers/net/wireless/ath/ath9k/init.c      |   3 +-
 drivers/net/wireless/ath/ath9k/recv.c      |   9 +-
 drivers/net/wireless/ath/ath9k/xmit.c      | 244 ++++++---------------
 include/net/mac80211.h                     |  13 ++
 net/mac80211/driver-ops.h                  |   4 +-
 net/mac80211/tx.c                          |  13 ++
 16 files changed, 217 insertions(+), 343 deletions(-)

-- 
2.20.1

