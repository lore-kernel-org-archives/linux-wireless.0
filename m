Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDA1C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 21:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFAB208B3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 21:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSVrZlWN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EFAB208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbeJPFnx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 01:43:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46655 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbeJPFnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 01:43:53 -0400
Received: by mail-lj1-f194.google.com with SMTP id x3-v6so18909135lji.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 14:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ty4Q+yp50d5vevh6ycOiOzya/HdXcVK5ar7r873o8EU=;
        b=dSVrZlWNnjo+qKa9OaEAhtuurDYqL+rNFwayS3xKLVqa7sEo5USN1bGhbMiweHS6E4
         E3qScSWpju0MINbvq878DFq9l1v/Vw2vslEg2IdwSnZ+sH8xTa/qtjh0axSOOzYpeQu3
         jRck2p5+RFQ3pwkRiFf273NzYSwLvlHmSgfhbpNIqLfbcTyATrV5QLoEyvHLQalhYo+o
         ugsre7n1pvE9BSTWjY00Uv8oNv0a7uRigonoqKsBsd4t7ekFpvwqSXofHz3c8k2GkdFV
         HGZnrPZ8KnChhkF5JsxeTuxZunvf7R4kgqc/QKypK26bt+6HiofguiCiDsmdu0lkLSaC
         qqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ty4Q+yp50d5vevh6ycOiOzya/HdXcVK5ar7r873o8EU=;
        b=HJAbNZIB/QY6WzbikNznfjLeRZlsib7nL2QY17ZCqLC2emyDumz8ebCVsgd0OGDuTf
         o6GHeCqfUrBKFoVOaxnMLriKt2Elk6m43MVBGYl1zoHjy3A98qRTKZqylZUrhWYEhmy1
         tAk9vNtErQEjpigkBP8IA5Xjm+Ezlr3v41x34NslAKoZk0tb3lcVgRRa6cZS+furcKss
         Oujq/l+HWYDl7yYeFll7QYb8W/fxFwqRq2iz0fidjPMzYzJt9YRF+tSbvIGuxv9heksw
         /UjAK+OxgVpiL/BWXR14o7cqnkqigQPNccTq1sEZWCCglsBnN2ngSG6LiPVo65Nhet2J
         Dh5A==
X-Gm-Message-State: ABuFfoiYO8Nwoi92Emj3Qoki81su4Qo9njJBxhoxq3Lts/AV55KhPBJU
        pRnG24Npgx3hWVVCss09DE15u9JCroH8EHbp0cY3Yg==
X-Google-Smtp-Source: ACcGV63HdBDEeGA+pDS8pSUmTRNmwB3mLyUxhP9JPufY91nD3LNph6XfSjwPFtseIm96QuxXtnWrjT3WQg4MchroZm8=
X-Received: by 2002:a2e:d11:: with SMTP id 17-v6mr12994040ljn.18.1539640604766;
 Mon, 15 Oct 2018 14:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <1537766878-11238-1-git-send-email-vnaralas@codeaurora.org> <87va672nib.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87va672nib.fsf@kamboji.qca.qualcomm.com>
From:   Kan Yan <kyan@google.com>
Date:   Mon, 15 Oct 2018 14:56:33 -0700
Message-ID: <CA+iem5v7HUuPeXv5bG9=xhW_yhyUvq4R+Ybw+wBm1Niha77iqA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Add wrapper function to ath10k debug
To:     kvalo@codeaurora.org
Cc:     vnaralas@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Johannes had an interesting idea to use trace_ath10k_log_dbg_enabled().
> Could you investigate if that would work? That way we might get the
> performance improvement even when is enabled CONFIG_ATH10K_TRACING (but
> actual trace point is disabled, of course).

That's a good idea. This patch was originally made for Google Wifi's
3.18 kernel and It does use trace_ath10k_log_dbg_enabled():
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/391891
+#define ath10k_dbg(ar, mask, format, ...)                              \
+       do {                                                            \
+               if (unlikely((ath10k_debug_mask & mask) ||              \
+                             trace_ath10k_log_dbg_enabled())) {        \
+                       __ath10k_dbg(ar, mask, format, ##__VA_ARGS__);  \
+               }                                                       \
+       } while (0)
