Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45118 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2IESOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 14:14:48 -0400
Received: by eekc1 with SMTP id c1so356925eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 11:14:47 -0700 (PDT)
Date: Wed, 5 Sep 2012 20:14:37 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
Message-ID: <20120905201437.70c008ca@destiny.ordissimo> (sfid-20120905_201537_078255_8441662C)
In-Reply-To: <50478E10.6030808@lwfinger.net>
References: <20120905185510.2ab501cd@destiny.ordissimo>
	<50478E10.6030808@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 05 Sep 2012 12:38:24 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> I have two different revisions of the RTL8188CE card. The newer one, marked 
> RTL8188CE-VL, gives the following lspci output:
> 
> 06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 
> 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
>          Subsystem: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi 
> Adapter [10ec:8176]
>          Flags: bus master, fast devsel, latency 0, IRQ 20
>          I/O ports at 4000 [size=256]
>          Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
>          Capabilities: [40] Power Management version 3
>          Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>          Capabilities: [70] Express Endpoint, MSI 00
>          Capabilities: [100] Advanced Error Reporting
>          Capabilities: [140] Virtual Channel
>          Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
>          Kernel driver in use: rtl8192ce
> 
> It certainly does not yield the rx descriptor problem. Please send the lspci 
> output when the driver has not been loaded.

The subsystem ID is different on my wireless card (8212):

06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8212]
        Flags: bus master, fast devsel, latency 0, IRQ 3
        I/O ports at 3000 [size=256]
        Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00

This id is nowhere to be found in the rtlwifi driver. The only matches in
Google are my previous problem report (FWLPS freeze) and windows driver
listings.

Anisse
