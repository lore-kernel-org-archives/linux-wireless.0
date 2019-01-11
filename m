Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA261C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 19:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 918C22183F
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 19:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rN3c5XCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfAKTB4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 14:01:56 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:36551 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731448AbfAKTB4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 14:01:56 -0500
Received: by mail-pl1-f174.google.com with SMTP id g9so7154107plo.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2019 11:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=brvBpXnmSOjKkTiVRjzm9/pPuq624cDtelWBkx2COng=;
        b=rN3c5XCdOTXQUcHgp8dDuFvUh9vkcUF+RNbjmtusZrCyMY727z3l9ym6xKjRD3x2xw
         NxnuYtjhiKJ8aGhzk2lUFxBdK6OpbVNSmXuot+iCcOt8VUZHlpQ/P+6aaVUP4syjrIjy
         0LDZZ7k5JSNVRBNZIK3evNUQcPia2nqUOdzbbsXal0Nz111U7/rt097A9fAzQpCj2p3S
         9GeVjFd+DI4PxQx0bB+DkXCCpQCczfgEy1ROoyYAAh8S/trOCLCzHnuhpVlvSUsWZpiX
         4PC7P0F1oaXJraJUCp+r6K85FaQXmZdj7HtSws6WplKX0/lA2yeXQBsR81srj/3/q/J7
         ktrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=brvBpXnmSOjKkTiVRjzm9/pPuq624cDtelWBkx2COng=;
        b=Rw+hyHBI+s3ja8KjfPi3q9xFThVgsZpPdM41daH8qsA1TpxVqOFDaMMiKwW+QwIC1M
         5dTTtdFVyVqTIglu6VL1lhQjvevHLofpxR+RgN16LVj1VgEynScZd4cYVQGHpW2J+KNu
         21MhL7/Wp0heSh7lHzL6k+zG6Ta4KvGPPIYNae8ycNje86SpeAn3WGgMPlDz0phbw9JM
         jXsd+NOXsuDYty78IAm03VypGOBQgEYY2MwwZHsyGkbWh73alFFUuvo/TWdlVAi8YEqc
         5IABbc2/AheBo2GCpgS2ri1LzfKU3g13Ysmv1B2skGRcnfUN9abAlTbiB8pouo/+yjBT
         XBhw==
X-Gm-Message-State: AJcUukfNFeOG3rf6BHP9rVr1AL4HeNuPKTqcyOswWWmb2vvnsCr+mzj2
        ppBJSHJlhMa2HLH+xwK00fy3xA4O
X-Google-Smtp-Source: ALg8bN4O6iaMmqUxOfpwkBGGIXzo5bfWb6KO8znj+lTekKnKH1ZCa9qGcK+SJibVWgOh/V6i4ybgDw==
X-Received: by 2002:a17:902:8f83:: with SMTP id z3mr15359936plo.328.1547233314651;
        Fri, 11 Jan 2019 11:01:54 -0800 (PST)
Received: from ?IPv6:2607:fb90:4ae:283a:c67:ea6e:60b6:161f? ([2607:fb90:4ae:283a:c67:ea6e:60b6:161f])
        by smtp.gmail.com with ESMTPSA id e187sm99596124pfa.130.2019.01.11.11.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jan 2019 11:01:53 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
From:   Rosen Penev <rosenp@gmail.com>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
Date:   Fri, 11 Jan 2019 11:01:52 -0800
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com> <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On Jan 11, 2019, at 09:29, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wr=
ote:

>>=20
>> I have an ALFA AWUS036ACM and whenever I plug it in, the XHCI driver
>> dies. This is on an ASRock X370 motherboard. Kernel 4.20 Arch Linux.
>>=20
>> After plugging in the adapter, the integrated wireless chip (Intel
>> 3168) also dies. Disabling the motherboard wireless does not help.
>> Here are two fairly similar logs. First with Intel 3168 and the second
>> with it disabled in UEFI.
>>=20
>=20
> [...]
>=20
>> Without iwlwifi:
>>=20
>> kernel: usb 1-14: new high-speed USB device number 3 using xhci_hcd
>> kernel: usb 1-14: New USB device found, idVendor=3D0e8d, idProduct=3D7612=
,
>> bcdDevice=3D 1.00
>> kernel: usb 1-14: New USB device strings: Mfr=3D2, Product=3D3, SerialNum=
ber=3D4
>> usb 1-14: Product: Wireless
>> kernel: usb 1-14: Manufacturer: MediaTek Inc.
>> kernel: usb 1-14: SerialNumber: 000000000
>> mtp-probe[1400]: checking bus 1, device 3:
>> "/sys/devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-14"
>> mtp-probe[1400]: bus: 1, device: 3 was not an MTP device
>> kernel: usb 1-14: reset high-speed USB device number 3 using xhci_hcd
>> kernel: mt76x2u 1-14:1.0: ASIC revision: 76120044
>> kernel: mt76x2u 1-14:1.0: ROM patch build: 20140408060640a
>> kernel: xhci_hcd 0000:03:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
>=20
> Are you using the driver in a VM or directly in the host? This is an
> error reported by AMD iommu driver
Direct. No VM used. This is the only peripheral causing this issue.
>=20
> Regards,
> Lorenzo
