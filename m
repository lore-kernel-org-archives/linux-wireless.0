Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD324C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94ABF2086D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 15:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OviTe/xQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbeLOPwu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 10:52:50 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44455 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbeLOPwu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 10:52:50 -0500
Received: by mail-pg1-f193.google.com with SMTP id t13so4074326pgr.11
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2018 07:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mQSHFSSt/zHEazV17xb4MzzQOw+OeBa84txzeV5NLm8=;
        b=OviTe/xQeoFKzuYxVDxZi771Zboi4e27q4KPWUu9r1+m2LT4K/A7WrNMWjVaSKh9pn
         cRZZqWvqEEJaUtoKylZc3PBddcn79uDYkrMNL3svvFlx7T0wvpDLcox1KQro6VqWkA4k
         ripyq+XNbAA1wauPhO/Ric6IvTO1yRyS1zS3k6s59yXlPDjL4LkWsPgFIb2+yA4KAgae
         tUbn/VbjpvK8nfyNjKLtDsoJb44dipEod4rbDqkIE3FhU5Sd0zRKp1UcoU2j5Y+uFmwE
         +HFA0o3Zp73IGsVOUdZttzn9qFTo7FhxS+iwuC5sW/QsTqqO3zEd30KssnsqvJJUBeL1
         6JQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mQSHFSSt/zHEazV17xb4MzzQOw+OeBa84txzeV5NLm8=;
        b=cfD/GapFL8LQoJzNx9E3Dd5i21T72KGVcVc072HFUE9O7M4/5/4J7DD7QJG713xJi3
         qFA1mnihQl4oC23SRnv4llsySnhZT3iFi/wUTzu1sxrFG8o4D+JRt21joNmF6zadGq6k
         iuflQB5XD17v5Vt/9kGDZ0c5xzGKfmLiZqlyWaDQMs2T0vC296mGK3gZHUw1cNzKzqBJ
         CwNTC3VSAyWM20jp4E0ulkvi4qEPUxEI9jE+2gE8aQ0r1r6hh3poGOuwinlCefubYdwz
         rVHSZvYqlpdkMCfBa6HGcrxkrWY4gSVEi3eY1TnuH8WOjuTmA1AG+YD2P+VeAwfjSGVu
         98gw==
X-Gm-Message-State: AA+aEWZFNKVx+ekPSn7gIfQW5rYskf9zpnPwES9zpaO2/84HMAgdV3oX
        mAMjQfmUQp7SBmEG5dW8NGoRKmH487o1/YlhzTw=
X-Google-Smtp-Source: AFSGD/UTvrnixs5BQPpjaeB1UgK4PEdVN3JzEDa2oNb+bIV9M9oqjvTSS3K2OmG1nyjBxgoWBiJaUM1a2kVp4Mg8nWw=
X-Received: by 2002:a63:26c1:: with SMTP id m184mr6025919pgm.367.1544889168641;
 Sat, 15 Dec 2018 07:52:48 -0800 (PST)
MIME-Version: 1.0
From:   Cyan Dro <cyandroi@gmail.com>
Date:   Sat, 15 Dec 2018 16:52:37 +0100
Message-ID: <CAAKJxXWW9cS=OtjESuFxZA-WiWoMJLX2CR6HfF01SdfuYrZtKg@mail.gmail.com>
Subject: Firmware regression: BCM43362 WiFi stops working when Bluetooth is connected
To:     Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I have a AMPAK AP6476 with BCM43362 (WiFi) and BCM2076 (Bluetooth) in
an Intel (Bay Trail) tablet. Ever since upgrading linux-firmware a few
weeks ago, I've been having seemingly random WiFi issues. Sometimes,
WiFi stops responding while being connected, or fails to authenticate
to WPA2-PSK networks. Today I realized why it happens seemingly
random: Once connected to a Bluetooth device, WiFi stops working. As
soon as I disconnect the Bluetooth device, WiFi starts working again.

Before upgrading, I've been using firmware 5.90.195.89 (2013-04-22)
added in af2a88b901af ("brcm: add firmware for the BCM43362 WLAN
device"). With that firmware, everything (except P2P) works fine, even
when connected to Bluetooth device(s).

The problem occurs with all publicly available newer firmware
versions. I have tested the following:
  - 5.90.240.0 (2017-10-23): be1c535efe7e ("brcm: update firmware for
bcm43362 sdio")
  - 5.90.244 (2018-05-16): 253a573936ee ("brcm: update firmware for
bcm43362 sdio")
  - 5.90.247 (2018-09-19): https://community.cypress.com/docs/DOC-15932

As a reproduction example, I connect to a WiFi network and then start
pinging some host. Once I connect to a Bluetooth device, pings are
sent only very sporadically, with long delays. Few seconds after I
disconnect from the Bluetooth device, they start working correctly
again.

"Broken" firmware (here 5.90.244):
  - Ping log: https://paste.ubuntu.com/p/qM6RKNPHV5/ (note the ping
time and "Destination Host Unreachable" after connecting to a
Bluetooth device)
  - Kernel log*: https://paste.ubuntu.com/p/CPYJB9R9Qj/

"Working" firmware (5.90.195.89):
  - Ping log: https://paste.ubuntu.com/p/v2BCHtGNrP/ (pings are
transmitted continuously)
  - Kernel log*: https://paste.ubuntu.com/p/wHZw6hYshZ/

NVRAM: https://paste.ubuntu.com/p/wCkQGFZGTS/ (extracted from the stock system)

It seems like Bluetooth and WiFi are somehow interfering with each
other. Looking at the kernel logs I can see that brcmfmac seems to
wake up every second, but doesn't always receive a packet...
Since it works with the old firmware, something in it must have
changed that broke this. Any ideas?

Aside from the KRACK fixes, I would like to use the newer firmware
because it finally has working P2P that has been broken for many years
now with the old firmware. :(

Thanks in advance!
Cyan

* Note: For privacy reasons, I have omitted a part of the log that
contains WiFi scan results. It is from before the problem happens, so
I hope you don't mind. :)
