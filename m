Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48B2C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 22:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAA0206B7
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 22:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Jl5ksSUL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABAA0206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbeLCW1A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 17:27:00 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37174 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbeLCW1A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 17:27:00 -0500
Received: by mail-pg1-f193.google.com with SMTP id 80so6365512pge.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2018 14:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UDMmGRWpQgoSO8XqLJ94ENmHrqirVedXPbVJlpoxDMo=;
        b=Jl5ksSUL/I8BhcGwHKJfhHwTVM9YXVvBW82sqmM6DWDmqJBTuXPj/mfWW2CeGW49V3
         OIc562Fku5EfDQbe7yA0zo0+wBEW0xrh3s8qJeJpLw/RyBgeBKQSqxxwzP/rBAqEGTLb
         zL50YSN4ERTCJzbx9kSHHrtahMzcJSd+c5rgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UDMmGRWpQgoSO8XqLJ94ENmHrqirVedXPbVJlpoxDMo=;
        b=mTzf1fldHGruR//422uANWljdKOdOp3m2Ni7BPmo4+z2zuVsSZPZwnDyStl9i6msqi
         MqOcnxioWxo2B7dK+yBPDd2EDpGkHtrojIzqXr8sYBCKDnS0eHMC1o6CVkNVBO7xusEm
         /QjGVydcbBTon8bYW/DtlBIXgHGGNT9u8pa5gwDLXMBY1ciqUtBTXJ71ynGx2x2OH3v0
         ZeN88VprdD7PFmbL58v2bfl9Rvf1jBjhnjYH8snzOM/Om2KhHvZ5dHk0aCgbYkPt/mx+
         Ko2x6wOjVMXTXAB3WCoaBQ35ZU08mrC1tY1nfonFr9m02llystAGb42bQHgtfZrbMgZf
         ndVQ==
X-Gm-Message-State: AA+aEWb0YNZQGEb9FkTtJAHzQSiXNGD8hWaojFF9zLYNiQDOAlBYxBl5
        KAM3TUDjrL7F/vmGZ+11Trlfxw==
X-Google-Smtp-Source: AFSGD/VUcLmpN7FzzakD++T+Cvd0mZUcvUEp590sFkX6lssO7JnDr864dwkx1cIpy53YB7I5WfjVuA==
X-Received: by 2002:a62:5716:: with SMTP id l22mr18110724pfb.16.1543876019284;
        Mon, 03 Dec 2018 14:26:59 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id p6sm18928538pfn.53.2018.12.03.14.26.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 14:26:57 -0800 (PST)
Date:   Mon, 3 Dec 2018 14:26:55 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Joe Perches <joe@perches.com>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2] mwifiex: debugfs: correct histogram spacing, formatting
Message-ID: <20181203222654.GA155572@google.com>
References: <20181130225303.143409-1-briannorris@chromium.org>
 <eef7598bb282218d4700986b15cf9f83a5e7edb5.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef7598bb282218d4700986b15cf9f83a5e7edb5.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, snippets of this file look like:

rx rates (in Mbps): 0=1M   1=2M2=5.5M  3=11M   4=6M   5=9M  6=12M
7=18M  8=24M  9=36M  10=48M  11=54M12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)
44-53=MCS0-9(VHT:BW20)54-63=MCS0-9(VHT:BW40)64-73=MCS0-9(VHT:BW80)
...
noise_flr[--96dBm] = 22
noise_flr[--95dBm] = 149
noise_flr[--94dBm] = 9
noise_flr[--93dBm] = 2

We're missing some spaces, and we're adding a minus sign ('-') on values
that are already negative signed integers.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2:
 * combine strings to improve readability and save a tiny bit of code

On Mon, Dec 03, 2018 at 10:32:52AM -0800, Joe Perches wrote:
> It's be smaller object code and more intelligible source to use
> a single coalesced string with one sprintf

Sure, I can do that.

Here's a v2 that combines both sets of strings in that way. I'm not
resending the other patches, since they were only related in concept
(since I was referring to debugfs for implementing the nl80211 stuff),
but have no real dependency.

@Kalle: I can resend the others as a new series if that helps.

 drivers/net/wireless/marvell/mwifiex/debugfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index cce70252fd96..cbe4493b3266 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -273,15 +273,13 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 		     "total samples = %d\n",
 		     atomic_read(&phist_data->num_samples));
 
-	p += sprintf(p, "rx rates (in Mbps): 0=1M   1=2M");
-	p += sprintf(p, "2=5.5M  3=11M   4=6M   5=9M  6=12M\n");
-	p += sprintf(p, "7=18M  8=24M  9=36M  10=48M  11=54M");
-	p += sprintf(p, "12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
+	p += sprintf(p,
+		     "rx rates (in Mbps): 0=1M   1=2M 2=5.5M  3=11M   4=6M   5=9M  6=12M\n"
+		     "7=18M  8=24M  9=36M  10=48M  11=54M 12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
-		p += sprintf(p, "44-53=MCS0-9(VHT:BW20)");
-		p += sprintf(p, "54-63=MCS0-9(VHT:BW40)");
-		p += sprintf(p, "64-73=MCS0-9(VHT:BW80)\n\n");
+		p += sprintf(p,
+			     "44-53=MCS0-9(VHT:BW20) 54-63=MCS0-9(VHT:BW40) 64-73=MCS0-9(VHT:BW80)\n\n");
 	} else {
 		p += sprintf(p, "\n");
 	}
@@ -310,7 +308,7 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	for (i = 0; i < MWIFIEX_MAX_NOISE_FLR; i++) {
 		value = atomic_read(&phist_data->noise_flr[i]);
 		if (value)
-			p += sprintf(p, "noise_flr[-%02ddBm] = %d\n",
+			p += sprintf(p, "noise_flr[%02ddBm] = %d\n",
 				(int)(i-128), value);
 	}
 	for (i = 0; i < MWIFIEX_MAX_SIG_STRENGTH; i++) {
-- 
2.20.0.rc1.387.gf8505762e3-goog

