Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46232 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3C0HqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 03:46:20 -0400
Received: by mail-ob0-f169.google.com with SMTP id oi10so6695354obb.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 00:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51521A8A.6060900@broadcom.com>
References: <51514F1B.1080207@dpets.co.uk>
	<5151639F.4010700@broadcom.com>
	<51516BC2.5010004@dpets.co.uk>
	<515173A4.7030607@broadcom.com>
	<515179C5.50406@dpets.co.uk>
	<51517E28.5000303@broadcom.com>
	<515182C6.5030305@dpets.co.uk>
	<51518682.7060503@broadcom.com>
	<515189C6.7070003@dpets.co.uk>
	<51518E14.3050500@broadcom.com>
	<CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com>
	<5151EC49.9030109@dpets.co.uk>
	<5151F088.2040408@hauke-m.de>
	<5151FB85.5080007@dpets.co.uk>
	<51521A8A.6060900@broadcom.com>
Date: Wed, 27 Mar 2013 08:46:19 +0100
Message-ID: <CACna6rwWNtPBJDShe1ia9dB_o40V_zZ1DFv677VSpmOmw083-A@mail.gmail.com> (sfid-20130327_084624_380737_246D8938)
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: John Talbut <jt@dpets.co.uk>, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/26 Arend van Spriel <arend@broadcom.com>:
> On 03/26/2013 08:48 PM, John Talbut wrote:
>> echo "14e4 4357" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
>> bash: /sys/bus/pci/drivers/bcma-pci-bridge/new_id: No such file or directory
>
> This could mean you do not have CONFIG_BCMA_HOST_PCI=y in your .config

Exactly. Make sure you have CONFIG_BCMA_HOST_PCI=y and that your
host_pci.c is not modified/hacked/whatever.

You can compare it with
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/bcma/host_pci.c
bcma_pci_bridge_tbl.

-- 
Rafał
