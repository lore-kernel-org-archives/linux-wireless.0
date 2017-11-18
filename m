Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35999 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764854AbdKRPwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 10:52:16 -0500
Received: by mail-oi0-f50.google.com with SMTP id n16so3624193oig.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Nov 2017 07:52:16 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>,
        linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
 <c6662534-db2f-61dc-142e-8015984c6813@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2524fe93-9d8a-523e-3256-2b495c951eb0@lwfinger.net> (sfid-20171118_165443_051529_867767A0)
Date: Sat, 18 Nov 2017 09:52:14 -0600
MIME-Version: 1.0
In-Reply-To: <c6662534-db2f-61dc-142e-8015984c6813@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2017 06:22 PM, Rákosi Gergely wrote:
> Hello Larry,
> 
> First of all, thanks your help.
> Lets see...here is the kernel version: 4.13.12-300
> The machine is an Asus ROG 553VE
> 
> The firmware which loading in the dmesg is : rtlwifi/rtl8723befw_36.bin
> The output of md5sum is : 1850c1308fbcd95e9f6a7f58ede1e35f

In mailing lists like this, top posting is not recommended. Please read 
http://www.idallen.com/topposting.html for a good explanation why top posting is 
not good, particularly for complicated threads.

You have the correct firmware. By the way, the code in 4.13.12 should be better 
that rtlwifi_new. That latter repo is deliberately kept a little bit behind just 
in case there is a regression.

With NO options in the loading, please run the following:

iw dev

You should only see one device. On the "Interface" line, note what your system 
calls the wifi device. Substitute that for the "wlan0" in the next command:

sudo iw dev wlan0 scan | egrep "SSID|signal"

Post that output. In addition, copy the dmesg output to some pastebin and post 
the link as well.

Larry
