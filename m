Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B52C43612
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C682087F
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 16:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pqiuBnnb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfAEQNP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 11:13:15 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46599 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfAEQNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 11:13:15 -0500
Received: by mail-ot1-f66.google.com with SMTP id w25so34481635otm.13;
        Sat, 05 Jan 2019 08:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DEUAb1t8Umvmxupcvpas8QpKculGCGn3a+HixUXZcYE=;
        b=pqiuBnnbMgvd6Gwa4RhyYs78YFcN/4RqiA0yzjx4UhsrL8mWfTGrxBK3OldaVThmBK
         WRUDlnGublVZH4TyCw0kahmfH9u6BswAFD+I9YwFF9d8O6X8T4XNvqHyZDSFccuFmy+B
         k0WKn4xe1aGJihgUrqTYGrvo55zdlxOqhpkUvCAMdsj+PwY/AX3Gp51ezMgtQ3K348FG
         4xg6529ZphPNztTJQmcbIF95asE79f11LwcCaaQWYZNHZ98mCoJ+8Md08oOXamA8nJYx
         elRPSoev22A4p4e321ubZ7l0pO39Xgc0Yhrp6Y9Dg7JZdr8M4jSyJe1gqUokPi8/6aBb
         SGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DEUAb1t8Umvmxupcvpas8QpKculGCGn3a+HixUXZcYE=;
        b=JL3znTbt/Ud4Kb4S7w72zMN6csnEEMTedn/w+c3wkDfkhWvzhFArb3WIwfpyPc8x17
         cKfqcZvTtH/JSC6lD8YtzMLPjqH4qU0UT9cQQgPP0IQNwbYKZy1SQdLmvGiFAh7r8UQe
         3bcLL/YULLXwXehcPKrs3ZYWtRk6rwGsI88e3FqBHP17UfxhtZ6W/LqodtZDyUpv/idb
         U6CAPjHS7Ka6sr/aXOnyEZ0krMtXw3d9DeC7qaS2Hip0f+HAqz3zJxwYLSdeUnqogGaa
         HLe9liKqGOOzPq2Dv7wOg9QYskFqAbHHVQAHNO5G9PWoibDOYudn0DG0KSRBmbItkJ1C
         IMcA==
X-Gm-Message-State: AJcUukcoOV6G1XL6muO7pS4wraBGa2un9O2/9T5GQ/sfrkQmX1NeFeyh
        DXZdlHtmBK5niJZUej/FEZMgM+b+
X-Google-Smtp-Source: ALg8bN700X1hwfkPhUuEk2cwXDpRapwN++wZUp1VeYyjAEP2yUAejlxn9PbdD9R1EsXeMUKei2mPsQ==
X-Received: by 2002:a9d:1e86:: with SMTP id n6mr41226515otn.9.1546704793638;
        Sat, 05 Jan 2019 08:13:13 -0800 (PST)
Received: from [192.168.1.102] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id b18sm35362076oii.51.2019.01.05.08.13.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jan 2019 08:13:13 -0800 (PST)
Subject: Re: [PATCH 1/4] rtlwifi: rtl8723ae: Take the FW LPS mode handling out
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <DB7PR07MB5353320B147CD781B7993783E48E0@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <f6406c9c-d095-6c9b-55af-0b2fd05c06bb@lwfinger.net>
 <DB7PR07MB5353984E3E78E24150ED3187E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7c1f25bc-dfc6-56e2-745c-4607f0f41159@lwfinger.net>
Date:   Sat, 5 Jan 2019 10:13:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <DB7PR07MB5353984E3E78E24150ED3187E48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/5/19 5:31 AM, Bernd Edlinger wrote:
> On 1/5/19 3:44 AM, Larry Finger wrote:
>> On 1/4/19 6:48 AM, Bernd Edlinger wrote:
>>> This appears to trigger a firmware bug and causes severe
>>> problems with rtl8723ae PCI devices.
>>>
>>> When the power save mode is activated for longer periods
>>> of time the firmware stops to receive any packets.
>>>
>>> This problem was exposed by commit 873ffe154ae0 ("rtlwifi:
>>> Fix logic error in enter/exit power-save mode").
>>>
>>> Previously the power save mode was only active rarely and
>>> only for a short time so that the problem was not noticeable.
>>>
>>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>>> ---
>>
>> While the Realtek firmware group has a chance to look for a bug, I would like you to perform a couple of tests on the original code.
>>
>> The driver has three module parameters that affect power save. The 'modinfo rtl8723ae' command lists them as
>>
>> parm:   ips:Set to 0 to not use link power save (default 1) (bool)
>> parm:   swlps:Set to 1 to use SW control power save (default 0) (bool)
>> parm:   fwlps:Set to 1 to use FW control power save (default 1) (bool)
>>
>> If you were to load rtl8723ae with 'ips=0', does it still fail?
>> If you were to load the driver with 'swlps=1 fwlps=0', does it still fail?
>>
> 
> this does not work:
> 
> modprobe rtl8723ae debug_mask=0xFFFFFFFF debug_level=5 ips=0
> 
> tail -f /var/log/syslog|grep "AP off"
> Jan  5 11:42:06 w-ed kernel: [ 7267.229713] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:42:08 w-ed kernel: [ 7269.276761] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:42:10 w-ed kernel: [ 7271.323758] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:42:12 w-ed kernel: [ 7273.370759] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:42:14 w-ed kernel: [ 7275.417753] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:42:14 w-ed kernel: [ 7275.417754] rtlwifi: AP off, try to reconnect now
> Jan  5 11:42:28 w-ed kernel: [ 7289.746676] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:42:40 w-ed kernel: [ 7302.028327] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:42:43 w-ed kernel: [ 7304.075327] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:42:45 w-ed kernel: [ 7306.122330] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:42:47 w-ed kernel: [ 7308.169292] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:42:49 w-ed kernel: [ 7310.216236] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:42:49 w-ed kernel: [ 7310.216238] rtlwifi: AP off, try to reconnect now
> Jan  5 11:43:05 w-ed kernel: [ 7326.592222] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:43:07 w-ed kernel: [ 7328.639076] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:43:09 w-ed kernel: [ 7330.686220] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:43:11 w-ed kernel: [ 7332.733078] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:43:13 w-ed kernel: [ 7334.779988] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:43:13 w-ed kernel: [ 7334.779989] rtlwifi: AP off, try to reconnect now
> Jan  5 11:43:28 w-ed kernel: [ 7349.108839] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:43:30 w-ed kernel: [ 7351.155837] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:43:32 w-ed kernel: [ 7353.202838] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:43:42 w-ed kernel: [ 7363.437779] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:43:46 w-ed kernel: [ 7367.531622] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:43:48 w-ed kernel: [ 7369.578597] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:43:50 w-ed kernel: [ 7371.625694] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:43:52 w-ed kernel: [ 7373.672691] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:43:54 w-ed kernel: [ 7375.719690] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:43:54 w-ed kernel: [ 7375.719691] rtlwifi: AP off, try to reconnect now
> Jan  5 11:44:09 w-ed kernel: [ 7390.048406] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:44:11 w-ed kernel: [ 7392.095678] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:44:13 w-ed kernel: [ 7394.142349] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:44:15 w-ed kernel: [ 7396.189352] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:44:17 w-ed kernel: [ 7398.236352] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:44:17 w-ed kernel: [ 7398.236353] rtlwifi: AP off, try to reconnect now
> Jan  5 11:44:31 w-ed kernel: [ 7412.565079] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:44:33 w-ed kernel: [ 7414.612167] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:44:35 w-ed kernel: [ 7416.659101] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:44:37 w-ed kernel: [ 7418.706035] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:44:39 w-ed kernel: [ 7420.753100] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:44:39 w-ed kernel: [ 7420.753101] rtlwifi: AP off, try to reconnect now
> Jan  5 11:44:54 w-ed kernel: [ 7435.081860] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:44:56 w-ed kernel: [ 7437.128857] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:45:08 w-ed kernel: [ 7449.410653] rtlwifi: :<0> AP off for 2 s
> Jan  5 11:45:10 w-ed kernel: [ 7451.457650] rtlwifi: :<0> AP off for 4 s
> Jan  5 11:45:12 w-ed kernel: [ 7453.504647] rtlwifi: :<0> AP off for 6 s
> Jan  5 11:45:14 w-ed kernel: [ 7455.551607] rtlwifi: :<0> AP off for 8 s
> Jan  5 11:45:16 w-ed kernel: [ 7457.598645] rtlwifi: :<0> AP off for 10 s
> Jan  5 11:45:16 w-ed kernel: [ 7457.598646] rtlwifi: AP off, try to reconnect now
> 
> 
> but this works:
> 
> modprobe rtl8723ae debug_mask=0xFFFFFFFF debug_level=5 swlps=1 fwlps=0

Yes, I think that is a better thing to do now. If and when Realtek finds a 
firmware bug, and when the new firmware is readily available, then there will 
not be a lot of code to reinstall.

Thanks for testing,

Larry


