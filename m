Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9A8C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D23D320840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D23D320840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbeKIR3C convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 12:29:02 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:41015 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbeKIR3C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 12:29:02 -0500
Received: from marcel-macbook.fritz.box (p4FF9F655.dip0.t-ipconnect.de [79.249.246.85])
        by mail.holtmann.org (Postfix) with ESMTPSA id 55872CF2C4;
        Fri,  9 Nov 2018 08:57:07 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.1 \(3445.101.1\))
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20181109000800.15431-1-jprvita@gmail.com>
Date:   Fri, 9 Nov 2018 08:49:37 +0100
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux@endlessm.com,
        =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <83CA40B2-1AF3-49FA-9F94-C84A3C916583@holtmann.org>
References: <20181109000800.15431-1-jprvita@gmail.com>
To:     =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
X-Mailer: Apple Mail (2.3445.101.1)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Joao Paulo,

>>>> I think Canonical were facing some wifi fw load error from some 8260
>>>> earlier module during the BT still loading the fw.
>>>> I believe we had later 8260 sku that fixed this issue.
>>> 
>>> But there are already 8260 that is affected by this bug in the wild.
>>> 
>>> Search "Bluetooth: hci0: Failed to send firmware data (-38)” and there are lots of user are affected.
>> 
>> which SKUs are these actually. What are the initial details about the boot loader. For the Bluetooth side, you should be able to grab them from dmesg or by running btmon.
>> 
>> So I am not in favor of this kind of hack and creating dependencies between drivers. If you only have a hammer, then everything looks like a nail. And this is a massive hammer trying to squash everything. This problem needs to be debugged. And this starts by providing affected SKU information and firmware information. So get the details about the SKU and its Bluetooth and WiFi boot loaders.
>> 
> 
> I have a Lenovo Yoga 900 which presents this problem and has the same bootloader / firmware information as Kai-Heng already posted:
> 
> [    5.992426] Bluetooth: Core ver 2.22
> [    5.992438] Bluetooth: HCI device and connection manager initialized
> [    5.992442] Bluetooth: HCI socket layer initialized
> [    5.992444] Bluetooth: L2CAP socket layer initialized
> [    5.992450] Bluetooth: SCO socket layer initialized
> [    6.004941] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2014
> [    6.010922] Bluetooth: hci0: Device revision is 5
> [    6.010923] Bluetooth: hci0: Secure boot is enabled
> [    6.010924] Bluetooth: hci0: OTP lock is enabled
> [    6.010925] Bluetooth: hci0: API lock is enabled
> [    6.010926] Bluetooth: hci0: Debug lock is disabled
> [    6.010927] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
> [    6.014253] bluetooth hci0: firmware: direct-loading firmware intel/ibt-11-5.sfi
> [    6.014256] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
> [    6.613961] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.613966] Bluetooth: BNEP filters: protocol multicast
> [    6.613974] Bluetooth: BNEP socket layer initialized
> [    6.983804] Bluetooth: hci0: Failed to send firmware data (-38)
> 
> And the following product id and revision, from usb-devices:
> 
> T:  Bus=01 Lev=01 Prnt=01 Port=06 Cnt=02 Dev#=  3 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=8087 ProdID=0a2b Rev=00.01
> C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> I understand the drawbacks with the approach presented here and lack of clear explanation of the problem, but I can confirm these patches work around the problem on my machine. Is there any extra info or test result I can provide to help debug this? I can also dedicate time to help write a different solution if some guidance is provided.
> 
> Kai-Heng, did you end up filling a Bugzilla entry for this?
> 
> Please CC-me on the replies as I'm not receiving emails from linux-bluetooth or linux-wireless anymore.

our hardware teams from the Bluetooth and WiFi side really need to look at this. An inter-dependency between the firmware loading of two otherwise independent drivers is really not what I want to see upstream. However I have no idea which boot loaders are affected or if this is something that might be even possible to be fixed in operational firmware. If you can create a binary btmon trace file with the error happening and getting really every single message from the boot we might get a bit further to understand where it goes wrong.

Regards

Marcel

