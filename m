Return-Path: <SRS0=HTPg=VH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8385FC73C68
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 04:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0FB20665
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 04:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeZwZGDF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfGJEio (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jul 2019 00:38:44 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:46664 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGJEio (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jul 2019 00:38:44 -0400
Received: by mail-qt1-f172.google.com with SMTP id h21so1013364qtn.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2019 21:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+YAq0tX5cHYmhfL+qW+NNxA1y8Kq//o38Nx++NN4DN4=;
        b=OeZwZGDFv4ZGPLbNy6Lyh92eHDa+6qpWT0scrgB7YmFWVEtI+khB9krJ2zDqz5zZ7z
         Tpq6PEmMOWTtyGGnPCpqEbrxyXcMvJtMLAQGJz2UrMgx4yHZO1IvZgxi6mfLgrLWp/bD
         iVHoKP5LsVblp0D8toH8Bhjmu0cVaMm8DAdCATY6WyJL2vU2G6zAN4wItGmIG3d/MsY+
         t132hBAL6SfR2+WjuKfwJHqrSk1T7//bo5rRwRWInQxBHXeaR12pBN2SXyO+CfcrULqb
         zhKFKv5KdeU7r6Qe9/0FJRFYL/Kf+kGjUcvOtenZ5dzUxOae0WOt6diCr3datH6jyFLf
         y5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+YAq0tX5cHYmhfL+qW+NNxA1y8Kq//o38Nx++NN4DN4=;
        b=W4a7QqNysUq6xs7Dg3XvdC1GJxq0VWLg7xIvmdlvekvAVDnCs+xqpkgFCaaMU3QqFw
         Nt+YmQntdb8xPBqz3KBsD9Sr+IiDKFFrfBuO4UGit7ZOHEtqLCsB+YS9dDmDXpqtXQFv
         aSu9e6Rh8INLkKjdQrtcKqx3JcqbZj0wd4bkQykENIyn//+FW0W+B9qnIGeFQBL6gNIf
         HTi62/Exr3qbleyKtwqxBAGg5dm9OvkghpSYTSq3dfOKiQCjxH0H6jYqOrBDjRwSSpkD
         nlDuJ7Gk09kWNl7plR6Ty8S7ShICNeVN+2HssSs7FhSI6PS447IQrXobdfWqfdwtJFyV
         h5eQ==
X-Gm-Message-State: APjAAAXbPXOpmxpEnpWsOYx89eSHQdqgGXuZCo1wepqUDJA68N5WYirw
        g0luKmWTsYfTJ4hde3pSqwcTH579QbJtOvRvK7LXoA==
X-Google-Smtp-Source: APXvYqxI+wkG063ZoUVFxshhvSF0vuAdLiyPuy0DQXSjdrOoX+l111cTUoQ0dehVTGWa6E/p9+vxiqjuWD0J/WUGZ8c=
X-Received: by 2002:a0c:fad2:: with SMTP id p18mr18499443qvo.154.1562733523172;
 Tue, 09 Jul 2019 21:38:43 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?SsOhbiBWZXNlbMO9?= <jano.vesely@gmail.com>
Date:   Wed, 10 Jul 2019 00:38:32 -0400
Message-ID: <CA+K+NcRWLeE3-vah=urveMVxcgXYO0yFHYD=WNeuX_TdZ9+8-A@mail.gmail.com>
Subject: [5.2 regression] rtwpci + amd iommu
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     yhchuang@realtek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

after updating to 5.2 the wi-fi driver stopped working when the iommu
is enabled.
It fails to list the available wi-fi networks or connect to a known one.
booting with amd_iommu=off works around the problem.
The staging version in 5.1 and older worked OK with the iommu enabled

The device is:
04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8822BE
802.11a/b/g/n/ac WiFi adapter

I do see an IOMMU error in dmesg, but the originating device does not
match the nics pci location:
Jul 08 15:03:14 host kernel: rtw_pci 0000:04:00.0: start vif
xx:xx:xx:xx:xx:xx on port 0
Jul 08 15:03:14 host kernel: iommu ivhd0: AMD-Vi: Event logged
[INVALID_DEVICE_REQUEST device=00:00.1 pasid=0x00000
address=0xfffffffdf8140200 flags=0x0a00]
Jul 08 15:03:14 host kernel: rtw_pci 0000:04:00.0: stop vif
xx:xx:xx:xx:xx:xx on port 0
Jul 08 15:03:14 host NetworkManager[790]: <info>  [1562612594.8992]
device (wlp4s0): set-hw-addr: set MAC address to yy:yy:yy:yy:yy:yy
(scanning)
Jul 08 15:03:15 host kernel: rtw_pci 0000:04:00.0: start vif
yy:yy:yy:yy:yy:yy on port 0

let me know if I should provide any further info.
thanks,
Jan
