Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CFAC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 14:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D4342183F
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 14:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hre8wLC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfC3OWs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 30 Mar 2019 10:22:48 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38352 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbfC3OWs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Mar 2019 10:22:48 -0400
Received: by mail-wm1-f43.google.com with SMTP id w15so5997836wmc.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 Mar 2019 07:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Mmhx1Yb4WO/QsiLGzdQT6RORbAbq5FJ4NTZg9R+0y4E=;
        b=Hre8wLC1afU2A7LBzdzLrfysSlg8j+tp1ApPo1J8CWH3js+tx3RAl22DewNJ2wlTBT
         vjY56M/fg6ISSP3cK4PYYAemEChOqHbO7CmtAmJkCg/JKM69VUEKFgM59zExWL65EwGw
         Nscv9iF3afr1VELfsDhW8NY29BBD7M4Z3cUzgZSAC4fbCOBBkjKuwv/TIhAeNciUEkT3
         buUS6ppfYtoywm/NBuJuo/VLZVZIHqU/+us21LkNrsQNuet20x7wOOpA49sNaVOTtcGf
         KUNpgG1eaP/5xBhzDgy7kQBLCal47dYisKFc2mtXtX94/oOtSSXioCMWqUMOfc8Zb0yK
         f40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Mmhx1Yb4WO/QsiLGzdQT6RORbAbq5FJ4NTZg9R+0y4E=;
        b=ClhIe3L+AmATWOu5XcHL+H4rS3fvN4sUkL3omuPMaxd8qr/WXLtYDRsC7ibRKcakPA
         tk+hA9SzZBvY1jhiiQzYfCoDLq2pzPwcJRU5peYP50+1Ad1XUpDcGNPS2IpT0M69siCW
         ZAQAPjnkrKdowD74gMlApF/Qeb/oSiwva9C9xpEElijHYZyYVCD9ZStEcpPT751IFcDi
         cKKyuP7ms6prR2ZJT74d1vpQdzSDpX9AlsEj0Cc76AtQNARgYdqXEzh5kGfHmUK+gdD6
         briZFsTvwjYcDEfp/JcVogZBh4G6KL25Mh0XwZJv6LGduCHQLusccf/G/nZudcLI5uVa
         3IRg==
X-Gm-Message-State: APjAAAUmx2ynH0yOMi2hgpiDi51CK8kGLPmOkJWqoDnsu6Jn587cyEF3
        /KRzKE/HoDcKUziduUfNlHtTx7C4LgPnbYDcrG1yhtWM
X-Google-Smtp-Source: APXvYqx4/HgUF8Y7VhQ+wSzqBl+j2RGR0DxUe9HOxn2xYvO35qmDUg2RPUaOb0sB2rrLEoemoYf1ElM6iE8puXJ6iUc=
X-Received: by 2002:a1c:7e51:: with SMTP id z78mr7028906wmc.82.1553955766711;
 Sat, 30 Mar 2019 07:22:46 -0700 (PDT)
MIME-Version: 1.0
From:   Matej Uhlik <matej.uhlik@gmail.com>
Date:   Sat, 30 Mar 2019 15:22:35 +0100
Message-ID: <CA+xR2TUfhF1MSvFHaJW_0PDs4zBczQFXmEJX7OGZ_n=9qJF67w@mail.gmail.com>
Subject: Patch for mac80211_hwsim to use multiple BSSID
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,



I need to create patch that will do the following -> enables driver to
respond with ACK to more than just one BSSID targeted frames. This is
idea for SDWN solution namely Odin Wi-5, which works in a way, where
AP is called agent, and is hosting many APs called LVAP(Light Virtual
Access Point). The thing is, that normal AP is responding to one
BSSID, the one that is assigned to him from manufacturer. In this case
I need to make the driver, behaving as AP, respond to more than just
one BSSID. These BSSIDs should be stored in text file.



I am attaching link for ath9k driver, which has done the author of
Odin. You can take this as example, of what am I trying to do here.



https://github.com/Wi5/odin-wi5/blob/master/odin-patch-driver-ath9k/ath9k-bssid-mask.patch



If anyone has any idea, how can I do the same in mac80211_hwsim, I
would be more than happy. I am using Mininet-Wifi which is
incorporating this mac80211_hwsim driver, and thats why I need to
alter patch this driver.



Regards,

Matej.
