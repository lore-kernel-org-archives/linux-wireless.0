Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E3DC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5264420827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A65l1MzP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5264420827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbeKEU5G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:57:06 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:42068 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeKEU5G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:57:06 -0500
Received: by mail-qk1-f180.google.com with SMTP id u68so13947261qkg.9
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SlWIgPrK4QLcAbiMaKWB2F8PUg4b+wX/Gp09EkAupA0=;
        b=A65l1MzPwRWDBLxju7wxt3QzSjQpjpNDvWLl6MNflitfnWi/qbtAog84VW/7RkSUd+
         9Sbw+2ejW+3T7M5JI/sJYSF2rcClSquYDb0p+tEQEJ4/nX+w+IyA/WLWBhSP9CXqBaiw
         8BxkwF8QQYm1Z3JvwU2JUh4ury3WIlb8boZcHTvcWKCbDln3RIvoYqibFRZ7WalvATC2
         nC4U3TELl3VNRNj4Jxn1GHgzLqfWzlEJJZqe30yBMFNlDCmbgpxSLEFTs5liqqxy6ZN9
         fzqX/DqslruWpqWRipyCaZh9jzwitlsm9HDzx82vP68zxg1ERefNj3HYi4jHelHaqr9r
         LSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SlWIgPrK4QLcAbiMaKWB2F8PUg4b+wX/Gp09EkAupA0=;
        b=J/tf2wNMpU6ai6FhG61wWAEPquO9tcAiERu5JyNbaGNChT1UnqRqoHHLPiJ02A3fFi
         kHplNWzaMQ+lNy/ElzdQafMvoeedbHYGbIJGdEbS81X0AT541xEC1X8RNwQ6NqcCg2qE
         OJAHJfsbDmDSBVFY8/7ty1Iryniyo4inkCA7Z2oH8ieqIXLyKyKBobbMKaHiQ/Gf+aza
         f4gpzD7qxRdqRv4BKMBnYU7DX3n7DnDq9DA+gRtLBS5auy/RKCiSjBMiE3jtNvv1J+Iq
         FUb+nrMd8L6O+JF5TC5BFK+VeIR/wkNMR7nvPLqR6lahA4OFockehHzfzmZW/bPKqiZ/
         ON8A==
X-Gm-Message-State: AGRZ1gLZhXDdSd3W7wFuGpO0P5HZVhxl6lsDXeyC6YTYxVLu7peeErEc
        yLTQ8Rzv8oiY1qsjTEeyjaIWDUmYHLTPt4Gniqle+A==
X-Google-Smtp-Source: AJdET5edXDxWKJAcgqvItjlMo7jw9l3pfAwrFI2/EoNNND9ozpT2eq3LWRj6mKzZx3bXlhhJbEtyBkYiVJ93oWcktwI=
X-Received: by 2002:a0c:9d81:: with SMTP id s1mr6772828qvd.82.1541417867504;
 Mon, 05 Nov 2018 03:37:47 -0800 (PST)
MIME-Version: 1.0
From:   Menion <menion@gmail.com>
Date:   Mon, 5 Nov 2018 12:37:36 +0100
Message-ID: <CAJVZm6dHuQPMrU+tSyZe_nsFcmmJ75byG+JbOzcHUeey9LpjDA@mail.gmail.com>
Subject: RTL8188EUS support
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all
I have a question about the support of RTL8188EUS chipset (which I
have in a TpLink 0bda:8179 usb dongle)
This dongle works with the wext staging driver r8188eu driver. Is it
meant to be supported in the rtl2xxx driver?
Bye
