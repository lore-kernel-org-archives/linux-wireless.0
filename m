Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0A9C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26EA920869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfA2Kba (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 05:31:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43571 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfA2Kba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 05:31:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so21383984wrs.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 02:31:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=NHlKTPudAva8lIMgwlWvmnGYf4Z+DlX26qMCxRVv5QQ=;
        b=h9b6hahm4lJdPgri9xiw4JTgsi4BrjbNsHt4v6KVmFvZ3Yek2qjwUdPtPF66WS3YVu
         JDYUjL47fe/9XJGeTSk7HlqF1MRkVcbMF0nGXbG0C/Ez9BDZvbdOv4y3/gNZFUZKXWtf
         oGN5tGY1sv+Mgy2DiFkOsUJnQosywXxpI8sOE9tYqSw6h1FU2tdU8rb4X64h7nvlLNCh
         O7DoX5knAn9LhNa7VfzQDFLBrIJKIwonQP9SCjYMKGnuWafY91AbPZlUeT4fE//stFZU
         rGQZV/TPinP6ahmMDzFZFmzaKbRFXsXxZNyP1j9rKEQapf4K24b+X+8Ktw48FBUdgFEN
         ylUw==
X-Gm-Message-State: AJcUukeRJl0ZUdchDz6UDBhQRKokcJMtGClsa4aRVU5bvVldcgnWYqjB
        3AacSQDkRar+WRrUWvjVjKe3KKzaF8nwOQ==
X-Google-Smtp-Source: ALg8bN6j/D4xAAZLeQUbup2QTgSdiNVSycHwuyABSo2g0YWLmJIvkZy83aa+4MLgoeRVjVYQXDfDoA==
X-Received: by 2002:adf:db51:: with SMTP id f17mr23970217wrj.90.1548757888049;
        Tue, 29 Jan 2019 02:31:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c65sm2692468wma.24.2019.01.29.02.31.27
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 02:31:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3E24B1825D2; Tue, 29 Jan 2019 11:31:26 +0100 (CET)
Subject: [PATCH] mac80211: Fix documentation strings for airtime-related
 variables
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Date:   Tue, 29 Jan 2019 11:31:26 +0100
Message-ID: <154875788593.12079.16584331507148842457.stgit@alrua-x1>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There was a typo in the documentation for weight_multiplier in mac80211.h,
and the doc was missing entirely for airtime and airtime_weight in sta_info.h.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/mac80211.h  |    2 +-
 net/mac80211/sta_info.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 294a8a36012a..396b0c079c3b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2365,7 +2365,7 @@ enum ieee80211_hw_flags {
  *	them are encountered. The default should typically not be changed,
  *	unless the driver has good reasons for needing more buffers.
  *
- * @weight_multipler: Driver specific airtime weight multiplier used while
+ * @weight_multiplier: Driver specific airtime weight multiplier used while
  *	refilling deficit of each TXQ.
  */
 struct ieee80211_hw {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 90e03ebccd3f..05647d835894 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -473,6 +473,9 @@ struct ieee80211_sta_rx_stats {
  * @last_seq_ctrl: last received seq/frag number from this STA (per TID
  *	plus one for non-QoS frames)
  * @tid_seq: per-TID sequence numbers for sending to this STA
+ * @airtime: per-AC struct airtime_info describing airtime statistics for this
+ *	station
+ * @airtime_weight: station weight for airtime fairness calculation purposes
  * @ampdu_mlme: A-MPDU state machine state
  * @mesh: mesh STA information
  * @debugfs_dir: debug filesystem directory dentry

