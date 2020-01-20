Return-Path: <SRS0=h6Hj=3J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D89C33CAF
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jan 2020 01:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC97C20678
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Jan 2020 01:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHe1gicD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgATBR0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 19 Jan 2020 20:17:26 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46386 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgATBR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Jan 2020 20:17:26 -0500
Received: by mail-ot1-f67.google.com with SMTP id r9so27277041otp.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jan 2020 17:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=StOpaJLAlWqkutfis3lnlKQAMkujEsqs3adqZGTuqtU=;
        b=CHe1gicDpMRIWgWVD6RYmR+YPM54YyVKfsgxYWheiieGlgDDQ2cYmP7KAxqnfNQE0d
         HUyn1H7gKxaC4c7yQKlRLL8UMPVEWtU3/rwsUm4gAwJaaeV7OI5S7bFDgjG2WJZ+apQN
         mpZkC9JI/2Vdr8NelpZFfnY1L1fe692Hyeoo0SJALfqv/n8dAspkUYs5ftByScKxd6Cp
         wlVkeM8E/PQqKSsak1d3DZjZ1gS+SfavJ6hfgDusNlc+6H1rxoOP9Rk4maKx+YrdcuMh
         /l3liS4aXttK1vDOsfqBT8ExLVpypfrs+ug0/figx6YrSASzx4EcpnGAumvrcjPS8o1V
         jfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=StOpaJLAlWqkutfis3lnlKQAMkujEsqs3adqZGTuqtU=;
        b=Q05A2taXe0puhUbPrieUAQ/5xBpygRZt7CHfKY3yulKVByzQ8dep9Nwafg7vEBhRPv
         IqgyPSXovnFRRDJhdOp9U1Eyl1kXXJp7GCpubG4rb8ltzcHwgYHRc9AtShl0U/siL2TH
         0RRaeyyAlqXkrBXB4ickFbnA5ZT477kD5VV/nRhMqDWq40QqTMtfK+KqZ8IKDZ0p2ZpR
         9j7yB4Oq2Eeh0L7Yhfz020mK2i9Q30SKbK57J4JpKPJ7S+ZDZKEuR3lmfFrgmZ3jQq/5
         Jzre7Sq5QTY9aCBu6OeNU6tLh7uMjjwKMFWKPH6xLGKy3xevGXV6cE6TyzJc4UsFGMdl
         lchw==
X-Gm-Message-State: APjAAAXW57fb0K9lnI9iADqsTtwEjvB1XQvgwllx7YXrXFQn/MvZ40FP
        qc1MSZCuzvmAIXQjAgctJRJWoVySeGFbxd57kKQ=
X-Google-Smtp-Source: APXvYqzJBXncPu1iX62kEQJu6sinnzNaBEULRxsFr8HdQhzFT3dbS624tLGdIzYu/tapm7byQKwwPv2KzuoAnHzdW4Y=
X-Received: by 2002:a05:6830:1515:: with SMTP id k21mr13549208otp.177.1579483045276;
 Sun, 19 Jan 2020 17:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20200117083605.392-1-wgong@codeaurora.org>
In-Reply-To: <20200117083605.392-1-wgong@codeaurora.org>
From:   Justin Capella <justincapella@gmail.com>
Date:   Sun, 19 Jan 2020 17:17:14 -0800
Message-ID: <CAMrEMU-57qrCP3Kh_cna-QNCBfGu6G3e0Y_0-wg6axq_EuoCcw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: add retry mechanism for ath10k_start
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k <ath10k@lists.infradead.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Is the same address always used for "struct ath10k *ar = hw->priv" --
even when driver is stopped / bus errors are encountered? If not this
could potentially be use after free scenario?

Most code tries to protect the ->state with the config mutex, might
need to do that here too
