Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC05C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 10:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D7BB20651
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 10:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HraN7W2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfAIK1g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 05:27:36 -0500
Received: from mail-yw1-f50.google.com ([209.85.161.50]:44132 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbfAIK1f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 05:27:35 -0500
Received: by mail-yw1-f50.google.com with SMTP id b63so2745040ywc.11
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2019 02:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MUvfypqmKphGIiPRrMr55K3vx6w7mb8sfEuXbN6Bk8I=;
        b=HraN7W2QCHT6H7Q98ohdbojxG7Zh55Xtzn0vkYKamYEGFdQPw/GNW+j6QDcQDAe+E6
         6xu24kktT98p8Oe51k3ErSLF7VcSV81NcXPJawrZmjCwZthRDQobbLtTRTzsAFAnaXSW
         9el7e8E6iWS8HoXQARH9vOh+QjCkyWlH5FgP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MUvfypqmKphGIiPRrMr55K3vx6w7mb8sfEuXbN6Bk8I=;
        b=NRpsU3vfD6pWbpgElN5XlszOTHpSyvC/HDRbXivJVYASS6VZlx2u5RAFD9V2MJd9Yc
         SJZfa8PHEzTJ9u/DauV4qi5cND5oWttu3sil1xxY6221XXTB8qrCDxlCyGR6k3fBVemm
         kNdlo+I/IdWaNIImQrbfRMDRd1aC4BXIec2lAo05c26cH7Lzr1A4DW59FjX2sYQoOlDu
         hvFiIfo5xPwJ2WWD19oSJayIWPxEeOToLtyEa4ERB/6COQycRHMjjpGH2ETXiooUMYvR
         9q4oHP6cikusaqxRqIextpuCRYpaB3ppwbYx4l0J2FwYPBHOFZveBXa72BkMnnM9x4gy
         O8sw==
X-Gm-Message-State: AJcUukdYcJnYG5th/TT/uy1JCioHRo21OTnkR3TdTCm8pgtGepxiTKne
        /UtRzXUB2VDa1KQySLZRwIWFAQ==
X-Google-Smtp-Source: ALg8bN5V9JekWhjdqwwa8oVvgq4EPUhgrv0VG4iyAgjX1c2BuMG8UNJURmJrkORuoHBjqANams8/iA==
X-Received: by 2002:a81:5356:: with SMTP id h83mr4917772ywb.8.1547029654358;
        Wed, 09 Jan 2019 02:27:34 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id r188sm25734211ywb.30.2019.01.09.02.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 02:27:33 -0800 (PST)
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
Date:   Wed, 9 Jan 2019 11:27:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190108232646.GV11171@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/9/2019 12:26 AM, Russell King - ARM Linux wrote:
> On Tue, Jan 08, 2019 at 06:40:46PM +0200, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>> Response using Gmail on phone
>>
>> Unfortunately it had HTML and not sure if it made it to the list, so
>> copying your response in full below just in case. Russell, does the
>> commit below fix your problem?
>>
>> 861cb5eb467f brcmfmac: Fix access point mode
> 
>  From a quick test this evening, it does seem to allow brcmfmac to work
> with hostapd again, which is good news.
> 
> However, I've been seeing other issues with the brcmfmac over the course
> of the last week, which needs the brcmfmac module to be removed and
> re-loaded to rescue the situation - ultimately, it means that running
> brcmfmac in host AP mode is unreliable.  This is with 4.19 and my
> patch - we will see how 4.20 with the above mentioned patch behaves over
> the coming week.
> 
> [1036107.225569] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1036108.217519] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1043906.813243] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1043907.809184] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1044220.587626] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> [1045006.357728] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> [1049743.889412] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> [1061305.953430] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1061308.641378] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> [1061309.665234] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> [1061312.993053] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110

Is this with hostapd? If so, this br0 message suggest you let hostapd 
create a bridge, is that correct? Just trying to get a good picture in 
case I want to replicate things over here although I am pretty sure I do 
not have the same platform lying around here. Although, what platform do 
you have?

The timeout (-110) error can mean either firmware crashed or the sdio 
host controller went in limbo. If this happens again on 4.20 (or 
5.0-rc1), you could build the driver with CONFIG_BRCMDBG and load the 
driver with debug=0x100010. If it is a firmware crash it should show up 
in the log.

Regards,
Arend
