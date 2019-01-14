Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A126BC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 11:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6414520659
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 11:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y/XKEZn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfANLtN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:49:13 -0500
Received: from mail-yw1-f51.google.com ([209.85.161.51]:36833 "EHLO
        mail-yw1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfANLtN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 06:49:13 -0500
Received: by mail-yw1-f51.google.com with SMTP id i73so8480953ywg.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 03:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b/SbxToGf9aRAF/a//wfji0aLqmv2qaxkt8DAOAi6Jk=;
        b=Y/XKEZn/lo3jeUUgxmFsWrqPWiS1pXCKuc6zrvcQ0Eb3hxZG5z7ulNcG2sYUDhovyB
         cY7WxAhTaH3AJxcPyqwv/Jslzn8sRhWjMHy07YUby4ZBNC+nRa071bnJFxdkeo4l9cVs
         y4V5Cer8eLc1cHxtyZY1N0cV/IL5rd9Eq+CKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/SbxToGf9aRAF/a//wfji0aLqmv2qaxkt8DAOAi6Jk=;
        b=ig0Vr/Jx70MBruuW75J5VwRtsJc3ZE0zxhqnawKNwUr128qQXJ+nDTPaIrqHM0SWlH
         NVwNLdW28vrAQzgzUQF0SJRB6MfZaa9+PMvkaZx6pgACxCWZo+tKDBgou2DV6/qEDycd
         2j0cN+JgylfSfE++yOF9jh1f00RABTKL6dJHNw6S3g9nwoz89jUb6gcTSy9RU/VyxXX4
         xJQktG4Wyb0XENvcED7pBBEZ61fECutz5/grW5SCyp+4HuvB1qob+pHO1AfHEm0rJto/
         lci/zStWiyVpEadee17xd6vQrGVp4/uE2TXsmB/mNxFlZU/RDoozCnoNsTFIhNnu19Wa
         FRzQ==
X-Gm-Message-State: AJcUuker6/LH5nwUn3WPizAG1sYG9ipw/ref0CMRVY53muIBPlnkMywJ
        jFtXM6YZcG9f1CXc2xmY5xqzZA==
X-Google-Smtp-Source: ALg8bN7o3S0JKgVvRVN2XqTz6TJCYUlcokMU6Rwa5GMqR+aJYomkGWrcO+LrW4hn9r4nWB0JgGZUSQ==
X-Received: by 2002:a81:5485:: with SMTP id i127mr24008163ywb.160.1547466552006;
        Mon, 14 Jan 2019 03:49:12 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id d4sm54202ywe.104.2019.01.14.03.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 03:49:11 -0800 (PST)
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
To:     Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
 <20190111141543.GA2392@n2100.armlinux.org.uk>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
Date:   Mon, 14 Jan 2019 12:49:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190111141543.GA2392@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/11/2019 3:15 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2019 at 10:56:22AM +0000, Russell King - ARM Linux wrote:
>> On Wed, Jan 09, 2019 at 11:27:31AM +0100, Arend Van Spriel wrote:
>>> On 1/9/2019 12:26 AM, Russell King - ARM Linux wrote:
>>>> On Tue, Jan 08, 2019 at 06:40:46PM +0200, Kalle Valo wrote:
>>>>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>>>>
>>>>>> Response using Gmail on phone
>>>>>
>>>>> Unfortunately it had HTML and not sure if it made it to the list, so
>>>>> copying your response in full below just in case. Russell, does the
>>>>> commit below fix your problem?
>>>>>
>>>>> 861cb5eb467f brcmfmac: Fix access point mode
>>>>
>>>>  From a quick test this evening, it does seem to allow brcmfmac to work
>>>> with hostapd again, which is good news.
>>>>
>>>> However, I've been seeing other issues with the brcmfmac over the course
>>>> of the last week, which needs the brcmfmac module to be removed and
>>>> re-loaded to rescue the situation - ultimately, it means that running
>>>> brcmfmac in host AP mode is unreliable.  This is with 4.19 and my
>>>> patch - we will see how 4.20 with the above mentioned patch behaves over
>>>> the coming week.
>>>>
>>>> [1036107.225569] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1036108.217519] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1043906.813243] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1043907.809184] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1044220.587626] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
>>>> [1045006.357728] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
>>>> [1049743.889412] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
>>>> [1061305.953430] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1061308.641378] brcmfmac: send_key_to_dongle: wsec_key error (-110)
>>>> [1061309.665234] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
>>>> [1061312.993053] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
>>>
>>> Is this with hostapd? If so, this br0 message suggest you let hostapd create
>>> a bridge, is that correct? Just trying to get a good picture in case I want
>>> to replicate things over here although I am pretty sure I do not have the
>>> same platform lying around here. Although, what platform do you have?
>>
>> Yes, it's with hostapd.  With the nl80211 driver, hostapd will only add
>> the device to a bridge, rather than creating the bridge itself.
>>
>> I'm using Debian Stretch, and my /etc/network/interfaces contains:
>>
>> iface br0 inet manual
>>          bridge-ports eth0.nnn
>>          bridge-maxwait 0
>>
>> iface eth0.224 inet manual
>>
>> iface wlan0 inet manual
>>          pre-up nmcli d set wlan0 managed no
>>          hostapd /etc/hostapd/rmk-home.conf
>>
>> and these are scripted to be brought up in the order: eth0.224, then
>> br0, then wlan0.
>>
>> These are iMX6 Hummingboards - one is a Hummingboard2, the other is
>> a Hummingboard.  Both have the 4330 device on, and both are running
>> the same firmware.
>>
>>> The timeout (-110) error can mean either firmware crashed or the sdio host
>>> controller went in limbo. If this happens again on 4.20 (or 5.0-rc1), you
>>> could build the driver with CONFIG_BRCMDBG and load the driver with
>>> debug=0x100010. If it is a firmware crash it should show up in the log.
>>
>> Interestingly, I've just checked another Hummingboard2 running in
>> hostapd mode (with a 4.13 kernel) which had been up for over a year
>> until I recently did some maintenance on it.  It has a later firmware
>> and hasn't shown a problem.
>>
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464
>>
>> so I wonder if it's just that the firmware in the Debian package
>> (firmware-brcm80211) is outdated.  Any ideas why distros don't
>> carry the 2013 firmware?
> 
> Okay, it's happened again - leading up to the event:
> 
> [52429.342374] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> [52431.902035] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> [52431.910749] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO failed, -110
> [64477.184237] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> [72565.439122] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> 
> and I guess this is where things went pear shaped:
> 
> [77842.523962] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [77843.515863] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [78439.934016] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [78440.921980] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [81442.351749] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [81443.343667] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [157822.092920] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> [209836.023622] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [209838.651573] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> [209843.515226] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
> [219678.790941] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> 
> I'm now going to try with the later firmware:
> 
> brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4330/4 wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464

Could you try the compile and load test I suggested earlier. I will try 
to replicate things over here as well.

Regards,
Arend
