Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9356DC00319
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 10:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF9F2083D
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 10:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LSFZaxPI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfCBKDv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 05:03:51 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43621 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfCBKDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 05:03:51 -0500
Received: by mail-ed1-f68.google.com with SMTP id m35so377075ede.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2019 02:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=OvgHMV4tRFVKXZCI3Q/neLkiOI7l5f9O+mk9lq0rTq4=;
        b=LSFZaxPIgTcOzGbJ3Ai3epxgqP2IvWhGxszxiLbc8IUj3yjrFzyR2N/5ffY440rIsD
         xzKvRLEh84FTwOlxIOzB/GdZZiUamwCjcWA6xcZhzv0SHHPuzxdq3p4OLHK8TK1fSuti
         Yq50e2Z/xlsSutp2aqZTxBycLsoKRMmqmonyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=OvgHMV4tRFVKXZCI3Q/neLkiOI7l5f9O+mk9lq0rTq4=;
        b=kUOiDzF/Mj8D2g4fVL25KL0wAnSoyDtwqR3rbc6556Sb6jUM4FPqFVpQsPNAO6t+dK
         +g2Oxvw7IQZIXAU8Y2oPMzUnrO5+Wlc8+zaAN0/lGwB6QmrS90uH1ej+YD1sXlOFDCyq
         fCsHF5F5HbbrPE4AXdMaZBEg0xf3B/1HeXNADEJcAQnvZWjqW9s5FZRzkajFEeDEJlnp
         5QtAepd/9Qnw/gOr8uB3hqfXdYCdkBjP88bIxFeAbg/p8sURSHwzQApS7nLq0K9odC6w
         e3Ze0RdLnmq+VNw2Ec9F1F9QuqBBu5T1KaNShJKUGjUQL4gqNJ/CLM3Faam6E3MX2Qpk
         8kxg==
X-Gm-Message-State: APjAAAV/ssewsRlhfPXz7S1AfFGRIOslKvjEPc0qQkvL48ElsUDPNl/d
        VUqX+YewuN8T1zBH+UFZ2bmzaA==
X-Google-Smtp-Source: APXvYqznIUP9+hHbBSbYPhUw1A75g3kH/1H2k4nbA0JbCEmo/uuQC1Fpk8v52ipZlSTNWSL/gdXYdA==
X-Received: by 2002:a17:906:3112:: with SMTP id 18mr6091666ejx.84.1551521028889;
        Sat, 02 Mar 2019 02:03:48 -0800 (PST)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id r1sm219378eds.39.2019.03.02.02.03.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 02 Mar 2019 02:03:47 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     "David R. Bergstein" <david.r.bergstein@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tony Chuang <yhchuang@realtek.com>
CC:     Pkshih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Sat, 02 Mar 2019 11:03:46 +0100
Message-ID: <1693ddc0fd0.278a.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
 <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
User-Agent: AquaMail/1.18.2-1413 (build: 101800200)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac connection
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Op 2 maart 2019 04:52:46 schreef "David R. Bergstein" 
<david.r.bergstein@gmail.com>:

> Larry,
>
> Sorry about all these extra replies.  Shortly after I sent my last
> message my access point started recognizing the connection as 802.11ac
> with PHY Rate / Modulation Rate of 866.6 Mbps.  What is somewhat
> misleading is the information reported by iwconfig (see bit rate below).

My bet would be that it is nitrate at which beacon or probe response is 
received. Regardless I would suggest using iw in this day and age.

Regards,
Arend

> $ iwconfig wlo1
> wlo1      IEEE 802.11  ESSID:"XXXXXXXXXX-5G" 
>           Mode:Managed  Frequency:5.22 GHz  Access Point:
> xx:xx:xx:xx:xx:xx  
>           Bit Rate=6.5 Mb/s   Tx-Power=23 dBm  
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Power Management:on
>           Link Quality=70/70  Signal level=-40 dBm 
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:11   Missed beacon:0
>
> Sincerely,
>
> David R. Bergstein
>
> On 3/1/19 10:16 PM, David R. Bergstein wrote:
>> Larry,
>>
>> Please disregard my last message.  The firmware is now installed and the
>> rtw88 module is working with my wireless router.  The next hurdle
>> appears to be setting the speed to 802.11ac as it is currently
>> connecting as an 802.11n client.
>>
>> Sincerely,
>>
>> David R. Bergstein
>>
>> On 3/1/19 9:55 PM, David R. Bergstein wrote:
>>> Larry,
>>>
>>> Following up to your last reply, I blacklisted the r8822be module,
>>> rebooted and was unable to bring up the wireless interface via rtw88. 
>>> Below are some errors recorded in my system log:
>>>
>>>  
>>> [  267.509818] rtw_pci 0000:3d:00.0: Direct firmware load for
>>> rtw88/rtw8822b_fw.bin failed with error -2
>>> [  267.509821] rtw_pci 0000:3d:00.0: failed to request firmware
>>> [  267.511068] rtw_pci 0000:3d:00.0: mac power on failed
>>> [  267.511072] rtw_pci 0000:3d:00.0: failed to power on mac
>>> [  267.511073] rtw_pci 0000:3d:00.0: failed to setup chip efuse info
>>> [  267.511075] rtw_pci 0000:3d:00.0: failed to setup chip information
>>> [  267.512817] rtw_pci: probe of 0000:3d:00.0 failed with error -114
>>>
>>> As directed, I used the rtwpci module to perform load/unload the rtw88
>>> module before I saw the errors above.  Do I still need to install firmware?
>>>
>>> Sincerely,
>>>
>>> David R. Bergstein
>>>
>>> On 3/1/19 8:46 PM, Larry Finger wrote:
>>>> On 3/1/19 4:26 PM, David R. Bergstein wrote:
>>>>> Larry,
>>>>>
>>>>> Thanks for the response and detailed instructions, which allowed me to
>>>>> build and install the rtw88 kernel module.  I cannot however seem to get
>>>>> my system to actually use the module.  Just to recap this is an HP Omen
>>>>> laptop with secure boot disabled.  Upon boot-up both the new rtw88 and
>>>>> old r8822be modules are loaded.  If I unload the r8822be module the wifi
>>>>> network connection gets terminated, even if I unload/reload the rtw88
>>>>> module.
>>>>>
>>>>> Is there something else I should be doing prior to invoking rtw88, e.g.,
>>>>> blacklisting the old module?
>>>> Yes, r8822be must be blacklisted. Use the lsmod command to see what
>>>> modules are actually loaded. You load/unload rtw88 using the rtwpci
>>>> module.
>>>>
>>>> Larry
>>>>
>

Verzonden met AquaMail voor Android
https://www.mobisystems.com/aqua-mail


