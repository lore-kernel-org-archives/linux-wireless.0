Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f188.google.com ([209.85.216.188]:55386 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0CAPN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 10:13:26 -0500
Received: by pxi26 with SMTP id 26so902229pxi.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 07:13:25 -0800 (PST)
Date: Mon, 1 Mar 2010 23:13:29 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
Message-ID: <20100301231329.64e3dd3b@tom-lei>
In-Reply-To: <4B89E0D7.9020103@lwfinger.net>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
	<4B89520D.1000209@lwfinger.net>
	<d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
	<4B89E0D7.9020103@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>From e74b075cdb143d45be9b371ee8a8e2dcfc15ab34 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Sat, 27 Feb 2010 23:50:54 +0800
Subject: [PATCH] ath9k: decrease size of ath9k.ko

The patch defines the fields of 'valid_single_stream' and 'valid' in
struct ath_rate_table as char type, so decrease the size of ath9k.ko
about 2KB.

old ath9k.ko
[tom@tom-lei ath9k]$ size ath9k.ko
   text    data     bss     dec     hex filename
  69344    3080     168   72592   11b90 ath9k.ko

new ath9k.ko
[tom@tom-lei ath9k]$ size ath9k.ko
   text    data     bss     dec     hex filename
  67304    3080     168   70552   11398 ath9k.ko

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---

This version takes Larry's suggestion to define 'valid_single_stream'
and 'valid' as u8 instead of char.

---
 drivers/net/wireless/ath/ath9k/rc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 4f6d6fd..aeaaa88 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -110,8 +110,8 @@ struct ath_rate_table {
 	int rate_cnt;
 	int mcs_start;
 	struct {
-		int valid;
-		int valid_single_stream;
+		u8 valid;
+		u8 valid_single_stream;
 		u8 phy;
 		u32 ratekbps;
 		u32 user_ratekbps;
-- 
1.6.2.5



On Sat, 27 Feb 2010 21:19:51 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 02/27/2010 08:52 PM, Ming Lei wrote:
> > 2010/2/28 Larry Finger <Larry.Finger@lwfinger.net>:
> >> On 02/27/2010 10:56 AM, tom.leiming@gmail.com wrote:
> >>> From: Ming Lei <tom.leiming@gmail.com>
> > 
> > Either 'char' or 'u8' is OK, since both has one-byte size, isn't it?
> 
> It wasn't the size, but the content implied by the type.

