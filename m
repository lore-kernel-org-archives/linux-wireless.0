Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6784AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 11:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A632184D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 11:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nKKz6/Ea";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="olg/eOrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfCTLqc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 07:46:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbfCTLqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 07:46:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3D28B60F3D; Wed, 20 Mar 2019 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553082390;
        bh=VmzJX/2OLP/7dqiL/0LC3hiIYSPzgbIpQQ4mfE7q6Tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nKKz6/Ea+90ANz3th1l1Xb+M5n8MzA3pdbTdewSteeQuCqwRgpoai2X5iaHrrTXUo
         9nX3F6uvrYXSMjk3C52sdogmG4CIOUkSI8MwK13VPAZOh88+n1eMgT1Cf+eu8KkqNm
         GOUc5QQfkDCSQ4sZWlRXod6kUAiajoRGEUnFkkXU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 692EF60EA5;
        Wed, 20 Mar 2019 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553082389;
        bh=VmzJX/2OLP/7dqiL/0LC3hiIYSPzgbIpQQ4mfE7q6Tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=olg/eOrxZ+NpRske7lH3/mlo2Fv4kARCwdt65YGxxx9ipJ0nEKEV1qDoZeNK4BOMu
         w0xucxe/732dJSD205GpSvIbsK2AzwJDZ6wGnW8YLXBF9LsoCZ1EfDHXq6kO3FgGvM
         oSJKD+ptqG6HTfKrMuVTIiLZaSXb1SUfEiVgwdy4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Mar 2019 17:16:29 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Catrinel Catrinescu <cc@80211.de>, srichara@codeaurora.org
Subject: Re: [PATCH v2 0/2] Add xo calibration support for wifi rf clock
In-Reply-To: <2614783.8fX38OIfA2@bentobox>
References: <20190320044511.12172-1-govinds@codeaurora.org>
 <2614783.8fX38OIfA2@bentobox>
Message-ID: <010c3a8c56a85fb5d3c8194594f5b9c2@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sven,

On 2019-03-20 14:07, Sven Eckelmann wrote:
> On Wednesday, 20 March 2019 05:45:09 CET Govind Singh wrote:
>> PMIC XO is the clock source for wifi rf clock in integrated wifi
>> chipset ex: WCN3990. Due to board layout errors XO frequency drifts
>> can cause wifi rf clock inaccuracy.
>> XO calibration test tree in Factory Test Mode is used to find the
>> best frequency offset(for example +/-2KHz )by programming XO trim
>> register. This ensure system clock stays within required 20 ppm
>> WLAN rf clock.
>> 
>> Retrieve the xo trim offset via system firmware (e.g., device tree),
>> especially in the case where the device doesn't have a useful EEPROM
>> on which to store the calibrated XO offset (e.g., for integrated 
>> Wifi).
>> Calibrated XO offset is sent to fw, which compensate the clock drift
>> by programing the XO trim register.
> 
> Who is responsible to fill in this values in the device-tree?

This is populated via boot-loader/system fw(for chrome-OS its coreboot).
Post calibration QDART writes to non-volatile/persist region and
during boot up boot loader fills this value in dt node as there is
no otp region or EPROM available.

> On other
> products, the correct XTAL capacitor registers values are calibrated on
> different devices (in the same product line) separately to ensure that 
> each
> device has a minimal inaccuracy. During the boot of the device, the two 
> u8
> taken from params_for_tuning_caps (inside the EEPROM) are just written 
> to the
> AR_CH0_XTAL register (mapped to the correct the INDAC and OUTDAC 
> region).
> 
> Your patch here seems to be doing something similar (you may correct me 
> if I
> misinterpret something) but you are already saying that these devices 
> don't
> have an EEPROM. This is already quite odd because then we also wouldn't 
> have
> temperature compensation (also stored in per device EEPROM/precal data 
> for
> other devices).
> 
> So you move it to the device tree. By default, this device tree is most 
> likely
> a static thing which is shipped with the rest of the firmware. So no 
> per
> device data is stored in this DTB on the flash. To include device 
> specific
> information (mac addresses, calibration data, ...), you could also have 
> the
> bootloader (u-boot for example) change the device tree during the boot 
> process
> and let it inject the device specific XO trim register data.
> 
> How is this planned to work? Is the bootloader expected to modify the 
> device
> tree during the boot to provide the device specific xo-cal-data. If 
> yes, where
> is it getting the information from? And is there already support for 
> QDART for
> it?
> 
Per device data will be stored in NOR flash by QDART and dt entry will 
be populated during boot by bootloader.
Here we are trying to set the xo trim register of PMIC xtal, which is 
the base clk source of wifi rf clk.

> If you do this, why aren't you using the data from qcom,ath10k-pre-
> calibration-data. At least for other ath10k devices, it includes the
> previously mentioned tuning caps. It is the first time I heard about an 
> XO
> trim register and thus it might be something different than what I 
> expect.
> 
No, Integrated chip set ex:WCN3990 does not use 
ath10k-pre-calibration-data.

> 
> Last question: why is it an u32 when the message with xo_cal_data can 
> only
> transport an u8?
> 

Yes, this i will fix in next version.

> Kind regards,
> 	Sven

BR,
Govind
