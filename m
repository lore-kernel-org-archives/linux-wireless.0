Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5F0ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 23:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3C9207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 23:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5lBNyIl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3C9207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbeJYHsa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 03:48:30 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:35475 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbeJYHsa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 03:48:30 -0400
Received: by mail-ot1-f42.google.com with SMTP id 14so6809719oth.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 16:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dfyKbW4CJTQ3Tt7ha4oMrbcm82JXWtc8FWY/RQqz+yM=;
        b=g5lBNyIlavL4UGB9UV6UCiGdaT/N/k+noemMIoOWc1+h5VeUxwj7rbCpt2kRaU60Yt
         DjId1BlWLwJI/3eTvXn3TEvQg6JwJPWToNNWIi91C4wRmecJWE+VDXF4HGc8+uV7Qb3g
         Mj0XkLxQsKh0SpNREN1/njI9wnwEevJNuPkYsSJbOtWp6jlZDiDPhY7FaNeM7ix8XP37
         AGAGx23JFE/hodykrdJ2GC9YNc4R5LR/rbvWAB1Nv/bY8YKrhpqqUAap3KPHtYGP89BY
         htXoAfBPcb/sWnS/fZ970EbpCsJt0g7kX7lr900gX+bbxvNDMGh12lv2+0uuNDiRCyJX
         OcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=dfyKbW4CJTQ3Tt7ha4oMrbcm82JXWtc8FWY/RQqz+yM=;
        b=mgBFzIvz3yqoukVPQJiQCT/N8o2HXI1Fgw6/837MRP9DVIyhEsTWRh+EucZ3OJ5/NM
         6dWIu+I3NwSLU15rvomkbHVElILZGUaUsEBqsbZu5on9f5drbHOOgf8dm2wnr1vPky+i
         b+FKEnRwapGtsSdwzz79+eFY5yySoq+Edi/oX0TuwoNjMzOXbStEUjC/t9UPWiSrPHCr
         o5KzU/+UMvAF08cYNa2WP0xRShHthKjAticgcNMX/Z9OWmwTbjdqIQRR3HD9tJ37Iujv
         QSCnPDfZV51Tt/iYml9wLTUL6o1MIDjbrPaWTWZznbsr4773NmFq//nl+L8Dg7ou/WuQ
         s8iw==
X-Gm-Message-State: AGRZ1gJ9A+pSgdy2aXaBiw6glsOiyc2LYjTJ3mLerTwLGK3waAKQuV4t
        xaCVCk89J8o7RJGDLn1i1xKY3t1MCeP/90Y5HCM=
X-Google-Smtp-Source: AJdET5eWhkAUZD9/OtN+TkNg43cRkK665j752xQ8IE9IrhchEJmvaVEUnMk0XECXDHrmSqBLUZwDPdip52C1F4o49fM=
X-Received: by 2002:a9d:7347:: with SMTP id l7mr2779429otk.270.1540423107275;
 Wed, 24 Oct 2018 16:18:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 24 Oct 2018 16:18:26
 -0700 (PDT)
In-Reply-To: <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com> <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
 <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com> <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 25 Oct 2018 01:18:26 +0200
Message-ID: <CAKR_QVJ1smqU3nr1w4f4SUGjrmcLa0KiAzZn2O6RAyN4MRZ=sQ@mail.gmail.com>
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Ellie Revves <ellierevves@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

if your system is read-only then you should make a build with debug
option enabled:

inside your buildroot create this path: files/etc/modules.d/ and put
file named ath9k there which should contain "ath9k debug=0xffffffff"
(more info: https://openwrt.org/docs/guide-developer/build-system/use-buildsystem#custom_files)

rebuild and try boot again capturing bootlog
