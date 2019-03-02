Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA5EC43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 03:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5232085A
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 03:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ssls1+2E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfCBDwp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 22:52:45 -0500
Received: from mail-qt1-f169.google.com ([209.85.160.169]:42241 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCBDwo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 22:52:44 -0500
Received: by mail-qt1-f169.google.com with SMTP id u7so21100918qtg.9;
        Fri, 01 Mar 2019 19:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o++Y6Uw+NqVsBBV6dgabpTrIJ8D9SA8wOvO6o76f9Po=;
        b=Ssls1+2EVyvHJERrT4GD5Fp7+TFDZ2Wx9ZLcbKGI5fFdf3w9o6tFm0HV1J/eYDNQag
         lRCfPjKaBbGm4Pu5v0zb2LDFuPYfJo9oW13cXdDTxzJ2pjYQwOh71zd381eLPpreOO1b
         LWj/Y8dShx5O8zzSJZ62ksGnfE9dogCCK7eQm2/wtA71Gh0w3QiA17FcF/qGvRYIHG2C
         eD8ZJJZ563OEC65LnajWhYB84Q4VBE9AzYRWHf2c7HJFQOLvCJ43LQmXs8jGGsD9IGMG
         NW5uVoZERfun/YFBFBhSamRS6+EbUaE5SlfiD0/65jNeFE4btIbns8FZmIRXdGRDdgat
         7Tig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=o++Y6Uw+NqVsBBV6dgabpTrIJ8D9SA8wOvO6o76f9Po=;
        b=ILGugIrUHDi3XoHLqZGdlmgL7JBMw19A/Ek0qX5c9czATC/BDVxGDqfGTciIzW4NAd
         FNYc388xH9iD8ol15+yymbZ/j9EaFOSiTDF2RvwNc7dcs1Ka5maT6arz2TCEbvWveOmf
         6Dnu7QWd3jtz7bBwL5HbjRz6AX1scUk3mE5qiJC/QQBTrMDpNlgbd3zEvqNF+S6DUJT+
         OAlVWWiAoxkr261QLWIRBZK3FO7kLxjrTfAYywj3X9cN4LUuOR2knoe0u/AtYC8fHdS+
         +eFtyA2GLMzjlOsR0UTUeumQhNWbML2ckznHOJbJ78EaRL+w7qyQ5t/Wh3nCXBIrLgga
         Xiiw==
X-Gm-Message-State: APjAAAVQLJux1mdPQ0pBpfKJIsMCowXAAyrUF18+XtqxtupIqFbb1gjh
        NVJisRCJuBJHwc/5kAuMx+bRDhUN
X-Google-Smtp-Source: APXvYqwLejlW+xpHJA3iR02QFX5yPZTfnyT6drrSsSDsJ2rKXhnCfJGkoFJTPW+16iUWiJnfr7CvjQ==
X-Received: by 2002:ac8:1884:: with SMTP id s4mr6813933qtj.369.1551498762616;
        Fri, 01 Mar 2019 19:52:42 -0800 (PST)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id z43sm15447706qtj.66.2019.03.01.19.52.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 19:52:42 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
 <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
 <487c350c-c455-b490-8de5-1d68760aa3dc@lwfinger.net>
 <2e39892d-d206-e87f-c802-d427c54277cf@gmail.com>
 <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <27e1a339-023a-360b-1e5d-1a156fc5edd2@gmail.com>
Date:   Fri, 1 Mar 2019 22:52:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <8706d34c-1fac-84ba-759d-18d96750636b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

Sorry about all these extra replies.=C2=A0 Shortly after I sent my last
message my access point started recognizing the connection as 802.11ac
with PHY Rate / Modulation Rate of 866.6 Mbps.=C2=A0 What is somewhat
misleading is the information reported by iwconfig (see bit rate below).

$ iwconfig wlo1
wlo1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IEEE 802.11=C2=A0 ESSID:"XXXXXXXXXX-5G=
"=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Mode:Managed=C2=A0=
 Frequency:5.22 GHz=C2=A0 Access Point:
xx:xx:xx:xx:xx:xx =C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bit Rate=3D6.5 Mb/=
s=C2=A0=C2=A0 Tx-Power=3D23 dBm=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Retry short limit:=
7=C2=A0=C2=A0 RTS thr:off=C2=A0=C2=A0 Fragment thr:off
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Power Management:o=
n
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Link Quality=3D70/=
70=C2=A0 Signal level=3D-40 dBm=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Rx invalid nwid:0=C2=
=A0 Rx invalid crypt:0=C2=A0 Rx invalid frag:0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Tx excessive retri=
es:0=C2=A0 Invalid misc:11=C2=A0=C2=A0 Missed beacon:0

Sincerely,

David R. Bergstein

On 3/1/19 10:16 PM, David R. Bergstein wrote:
> Larry,
>
> Please disregard my last message.=C2=A0 The firmware is now installed a=
nd the
> rtw88 module is working with my wireless router.=C2=A0 The next hurdle
> appears to be setting the speed to 802.11ac as it is currently
> connecting as an 802.11n client.
>
> Sincerely,
>
> David R. Bergstein
>
> On 3/1/19 9:55 PM, David R. Bergstein wrote:
>> Larry,
>>
>> Following up to your last reply, I blacklisted the r8822be module,
>> rebooted and was unable to bring up the wireless interface via rtw88.=C2=
=A0
>> Below are some errors recorded in my system log:
>>
>> =C2=A0
>> [=C2=A0 267.509818] rtw_pci 0000:3d:00.0: Direct firmware load for
>> rtw88/rtw8822b_fw.bin failed with error -2
>> [=C2=A0 267.509821] rtw_pci 0000:3d:00.0: failed to request firmware
>> [=C2=A0 267.511068] rtw_pci 0000:3d:00.0: mac power on failed
>> [=C2=A0 267.511072] rtw_pci 0000:3d:00.0: failed to power on mac
>> [=C2=A0 267.511073] rtw_pci 0000:3d:00.0: failed to setup chip efuse i=
nfo
>> [=C2=A0 267.511075] rtw_pci 0000:3d:00.0: failed to setup chip informa=
tion
>> [=C2=A0 267.512817] rtw_pci: probe of 0000:3d:00.0 failed with error -=
114
>>
>> As directed, I used the rtwpci module to perform load/unload the rtw88=

>> module before I saw the errors above.=C2=A0 Do I still need to install=
 firmware?
>>
>> Sincerely,
>>
>> David R. Bergstein
>>
>> On 3/1/19 8:46 PM, Larry Finger wrote:
>>> On 3/1/19 4:26 PM, David R. Bergstein wrote:
>>>> Larry,
>>>>
>>>> Thanks for the response and detailed instructions, which allowed me =
to
>>>> build and install the rtw88 kernel module.=C2=A0 I cannot however se=
em to get
>>>> my system to actually use the module.=C2=A0 Just to recap this is an=
 HP Omen
>>>> laptop with secure boot disabled.=C2=A0 Upon boot-up both the new rt=
w88 and
>>>> old r8822be modules are loaded.=C2=A0 If I unload the r8822be module=
 the wifi
>>>> network connection gets terminated, even if I unload/reload the rtw8=
8
>>>> module.
>>>>
>>>> Is there something else I should be doing prior to invoking rtw88, e=
=2Eg.,
>>>> blacklisting the old module?
>>> Yes, r8822be must be blacklisted. Use the lsmod command to see what
>>> modules are actually loaded. You load/unload rtw88 using the rtwpci
>>> module.
>>>
>>> Larry
>>>

