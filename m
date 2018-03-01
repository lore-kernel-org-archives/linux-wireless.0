Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34882 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030379AbeCAN1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 08:27:36 -0500
Received: by mail-qk0-f193.google.com with SMTP id s188so7477389qkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 05:27:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <588e4d951bd84ea29dfc1a68353505e7@aphydexm01b.ap.qualcomm.com>
References: <1518685448-15317-1-git-send-email-govinds@codeaurora.org>
 <877eqwqfml.fsf@kamboji.qca.qualcomm.com> <CAK8P3a1KomtVHMidxtmx_gRF+92MWdHmeG0eTbcfUpbAaDPe3g@mail.gmail.com>
 <588e4d951bd84ea29dfc1a68353505e7@aphydexm01b.ap.qualcomm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 1 Mar 2018 14:27:35 +0100
Message-ID: <CAK8P3a06sDwL8iech_L3Q-zGxio3_RD8c7_-L3HHmFmb=Pq2UQ@mail.gmail.com> (sfid-20180301_142740_390079_9D9FBFCE)
Subject: Re: [PATCH] ath10k: Enable IOMMU support for WCN3990 target
To: Govind Singh <govinds@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 1, 2018 at 2:18 PM, Govind Singh <govinds@qti.qualcomm.com> wro=
te:
>>> The asm/dma-iommu.h header file exsists only on arm32, no other archite=
cture.
>>> I'm not sure about the purpose of the patch to start with:
>>> it's normally up to the platform code to allocate IOMMU domains, device=
 drivers should only need to manually interact with the IOMMU layer if they=
 need more than one domain, but this ath10k patch appears to be using the d=
efault domain and should have no effect as long as the platform code works =
correctly.
> Thanks Arnd, I have fixed this and migrated to  64bit API's(iommu_attach_=
device/iommu_detach_device/ iommu_get_domain_for_dev), will share the next =
revision.
> I tried using the default domain by adding the stream ID and mask in dt a=
nd no manual interaction, but it is resulting in TZ error and unhandled con=
text fault.
> Seems I need to provide explicit mapping range(aperture_start/ aperture_e=
nd) as this is only working combination for me..

I don't see why you need to do that at all, can you clarify?

The IOMMU should be set up implicitly for you here based on the iommus
property in DT,
with no driver changes at all. This should work on all architectures/

       Arnd
