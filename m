Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=BODY_SINGLE_WORD,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BDCC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622382070D
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KILRk/DG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfCNOKt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:10:49 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43713 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfCNOKt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:10:49 -0400
Received: by mail-oi1-f196.google.com with SMTP id 67so4475323oif.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 07:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=A1g1Vw9FtQKpKnY2LORsLdmO4xHwIYeOnqcv87rtlms=;
        b=KILRk/DGKOFhSWBybrEsm+5Se0N/PsuJmbr06fVXFuQbFkraA7kGOTZvuawzymJwng
         eODCAwE6Cv0vJZTsWHu48gnsoEzFeq+qHcEpHvJtN8y3e+KpiNjQ8RPQxSmQNmifzxHB
         +2kVeL90MKJYfO0ALjkWKHZYCWEAAZQx9uAgJ6qaKZJqjmsnX5fc3ajyF1X5i8ZjSYpI
         OKSjpkMe9BcXgi9Uozl8Np4snnjL/+0WdD360c3rAVOR4+sTYG2nnl8RhOtXdniZym/T
         mrnIw6KpdPFEivmyWP8DBe3KEjB/Wpcwo+o3OXMvnbi0CosvmuPPdnOYbpyLfj9C6PcP
         YtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=A1g1Vw9FtQKpKnY2LORsLdmO4xHwIYeOnqcv87rtlms=;
        b=HXx8CR1fvh3xQJWc2/CCk9tvBtKuROPsNYSefk0EvDC9rLUlfrQWrcXZdRgQJPi1iC
         yNjBlgo8SYae3k7ri/arJimoiTf/RrcPDp4LNwTeIjpWC578r0XukqnXxeVHKJJr9PX3
         0ldEG7GIRqRQRbzYTFTNfGAdGwVfcSuuyWZKO7+3VDUtTN4PaRSI3AnHrzNXN3XwLudu
         4xmi88f2PUJe89qvlgdX0xaesjDqUH/vNyBTeYd87/ZUbl8Tstv8k+LTHfRgFxYVUdfl
         irn7931q8QuxCgxbS5D2eMepeLlCyTIsIJKecHlkPcS3QlsQv0nSECrjLrLMNNt3R1oB
         1w9w==
X-Gm-Message-State: APjAAAUxZ6YklK0jMXr8wJlWm3sDpGvWQjTHvNU0AaJX5jzoa3QA9lFk
        qVUsXz0w9r+tcJzXEq5eudblvxAShDfXDL64+/fEqw==
X-Google-Smtp-Source: APXvYqxxGn8HbwD0lf2BlBj/EJgCMPEwf1JLCr67AbfCgKP19i7OdPHokcOhKUqcn5TpnAaNOxnmwD+0cHjHRzRo5WA=
X-Received: by 2002:aca:ab01:: with SMTP id u1mr2273622oie.30.1552572648790;
 Thu, 14 Mar 2019 07:10:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Thu, 14 Mar 2019 07:10:48
 -0700 (PDT)
In-Reply-To: <87zhpxzit5.fsf@codeaurora.org>
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
 <87o96f1cya.fsf@codeaurora.org> <CAKR_QVL+4f4Y8Edj_tVeDefa0YMJM6N5mrBnXUF6MnxEJ98=gQ@mail.gmail.com>
 <87zhpxzit5.fsf@codeaurora.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 14 Mar 2019 15:10:48 +0100
Message-ID: <CAKR_QV+Ogamn1uZxkOCAiNrPQ4PrMmqb-mMcuhY74MGS44An5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Done.
