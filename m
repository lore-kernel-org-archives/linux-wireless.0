Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9680AC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 21:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C68B20821
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 21:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZVbbW6gv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbfDPVTS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:19:18 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:39934 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfDPVTS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 17:19:18 -0400
Received: by mail-qt1-f174.google.com with SMTP id t28so25080488qte.6;
        Tue, 16 Apr 2019 14:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=krRt68KLEsOjmTvEFVx1sK86aD/lbvaJH64fxTuBNYE=;
        b=ZVbbW6gvpDtnRxcvwdQ0V1BcIAz+WWCva/JEL9oK9hk/kyDqY+4bUic94IAJetVLph
         9FzjYacpfcJSXn2dsJGTt/cvBapbioKYivAf4Dx8zgt4ST56pGDTuEHQWRr/zQAXyvCI
         cqcMJwZabeSv/b6YoMHtJI2HD5RF0xka7zMw4eF+m/E04kl2080rX+JL0hbP/k4rHzw2
         NKl6qah9Gr0OELct/YHvyWwcOkKjcYktL9jnSwvU49+enEAOZnbbG9BlCzYhHwYsZYCZ
         oGNi6rqWu+7NBFz7Zar7aJcfgLWI8sv8F++Mk8ReBlcKMDADgR6SkSdKuqRKXaVEbGkX
         j16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=krRt68KLEsOjmTvEFVx1sK86aD/lbvaJH64fxTuBNYE=;
        b=Lu9JtBOwprwZMQQNjI0WwpYw1HKuPqlhQS5FU3wnr47nGBlQAki55XculIEKugFlGO
         PCyr7RpIWfj5i0u3xpnlqucJ8yDYk1EhNR3r3GHpMaAdhlxyjRiwfo4SbvFW8fDGffA+
         2ggsiOGMCvPrss5BW40Unt/UD3Ci4eK/lB2g5iKTOInTw2wlrn+6/LFVI/lwQwnlVnUT
         sP9r96yZkYbqdi9Ih8Tlrf+T39F0K7zzT+55mf1eojpMQCwDlmF7oduD5KXMBOn7XHO9
         suhuR2eFwvDP3jf3YE3i8el3xnTOtmwSZaM7urZEbLDc6UBEnVoslb6O4qoGwoN7L8hD
         bWXg==
X-Gm-Message-State: APjAAAWAoKnNgocmU0HiwrW8NA/Kzmxsmu8x5x6LYA6U8geQyqUxBuLd
        nzOSNHBiuRKhs7PbqoYqGqGxftnG
X-Google-Smtp-Source: APXvYqw9MksTnQetWnkH3xw/OchkAavRYWbMoH9j4pyKgoRYVTKzsyo19snEkKhXUf5WKVeEV+LS/A==
X-Received: by 2002:ac8:1a55:: with SMTP id q21mr69551665qtk.20.1555449556452;
        Tue, 16 Apr 2019 14:19:16 -0700 (PDT)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id n46sm34285629qtn.75.2019.04.16.14.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 14:19:15 -0700 (PDT)
Subject: Re: rtlwifi-new v0.6 and dkms failures
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
 <60509a60-d0ea-d17f-8b79-e51c374717ba@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 mQGNBFuOpRoBDADZ5R/eYIWhqqdgyJWcNf/wRM38UOQIH+ef+S1aeedsMciGiboMQiu7AZf2
 pbizMQVdDK1DOFymP1PCJ1mWI+Ck+VlxosWOOvPcbh+Iir4kFzV/9aEp2BEbePu/Mb2NB5Q4
 MZBanRcmtfro4ZIbHIrga/foV6I92WQzt4yqMFKhU46mlSyQkFDgyaQ6qUU7b2H0mNwS9AAH
 vhIavAfdeWNqqO5adzgXwblZnwzbH84Kr2eqGCOLKzCn3jMsg5VHHu8isc8ZG7Eac+G+gJEn
 HAp4nQ4U6oBX/gLR6lk3Tpb9RIdQICFElM89pQOI+yQvStjC6s9jA0673iSzbuqzuYgCCf89
 n4GWfaZBsNF0vm9dwJUroM/D2SJLYTB9Czqh336jm+KK3EyVD9APULwBAQKKOLwG9TreEsKp
 VNs2RBjb/mbJTPT7meQBa9O9EP94dIWWtVkaPaX+nZP0bR5JYzsoAG16jnzNgxcf/6V1Y3Wy
 3+AU4sPiJY1PEBUtRIL8nAkAEQEAAbQwRGF2aWQgUi4gQmVyZ3N0ZWluIDxkYXZpZC5yLmJl
 cmdzdGVpbkBnbWFpbC5jb20+iQHOBBMBCgA4FiEEmajOzgQlh7dLtUxJC6xF9iYnYB8FAluO
 pRoCGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQC6xF9iYnYB9hiwv8C7fejEdiPk0i
 8uQzoxr9XVkKLck5IOuP/jA4YFEiF0Y5NCcvhfMEDmgMUKhzkAP7EZI+tL3hrybilY/YncBc
 PKkG3sdYvB0Tv48EfINQjOKv4WT3CG5qvxaEj+niBhBZ4xlcajqmHFwBQ1jAFmJr1ZJUMEqw
 nSm+/rE1eq83kGanWPFfamJD+mFELebTg+Rss1dFAh4qMO9Wv8mzooGLvanxBL51N7QxiXR0
 FuL2Aaqr/+RMtLnlNHDNGIkvPzSk8wKeySMbnVpSfyzBeIM+VgCGghehGjHtU3QWxElrdCmM
 Rg6BI53/xZLPUr2GrcftLkUGxb5OcgqqDZQUBHhW0H5N/T+Crc1dUUFnwJ+k0dw7JypzGL89
 sMsoi4hj1BORSRJzfuuK69GllXyzEGdjjupii2MbmMEMKJEo6SZSJAz4p69g/lMa+XPjFMot
 lbwgWW2/iotkSn2AFG4v7c98PiWzVSSy3D0f0Oaq36E640Um+mOtPMLfcoumTIoR1xhcuQGN
 BFuOpRoBDADiIkSQ/Kp8iLyNvPLExUN+RkAzMiVY2sHAp+RW3h+uL58uxYoL/cQ+9dS1IqSe
 PuQpyhGT3JtTUl0gh9NWmt9xE8TQCWBibOJp5qXd21zdyWAGFfgJ1B3QU6DjZihl4Eukc8N2
 /kcvovU9CGWmF3bPlOdhOxUIQEdWqA+sZyLK6qrwP2BRIRh6idF5d7LEqwV/ZfWQJ3lmyvfa
 g/M5JYL2EusYhpCEOreCvI+lP9Je3/ue6uMf6jC+w6/PAUjDWgBIbxkOghSL7jrbAhSCMaFv
 YCYYpfNt4D6/skumDO3XtirFUHEI7s0/RrDMNhY0CVR6XkWop0S9bEhBRu30G8PC516KxgD0
 ijQnMheCJnQJypWVO6+n4K2oagZZClUTVGbhKWcCwRA/dsSUgyduQPgkOcJseF40RTBZ+jrO
 /7J9hU0dm0w664mBXNiM2dDbq9rbCiZX1DTxlAn3tbFE7GaXQM26Q6jBOi04urxGpwEhQT4I
 OF/0fJdwkmKt2JsY6JcAEQEAAYkBtgQYAQoAIBYhBJmozs4EJYe3S7VMSQusRfYmJ2AfBQJb
 jqUaAhsMAAoJEAusRfYmJ2Af9coL+gLUcCdFwkOIpU9CakfVeplCepp0EaHcPpfIzPMb2v2W
 IkCiYzsrCqytyblBSCVgRk7QO+KQ7p6NHUn4keaAxRam+6/4+yfLcgTB44A0xYO04LzRVEY5
 8Vjek3/YJcvRPS4MCWTqbj/l0AEV7kVstkuyL8DdSnGYOZsk7JrwH/7EG5x3V1m6HOUj6aNX
 45o9J3dSUJI4ymKlB4PGVWf7gBf9whbECAEptcBHef1j9KrAfetL6QI2iOU00rqWME7CIkmb
 NnCSZuyqLcdl5AWCII7J0vc20qeon8Mps3jEPZcC8jIGBIkLgcbb0EmtqXtE9d+Quo+/5igR
 tDnFcUya7QZqP+edCK1BI3rvfZT07nMTOI88Ddd9Ha76ndUOjW4lrIwqq08N6pI4/EHaqrkA
 6BD6T0TrECEVfeFzudib/2M2KQo04fitQWH7fK8eGo8XmcgtnMH3tKcBwBBs3Zg0XjhSXr8K
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <96605e3f-002b-c28b-8e7c-566271bbec19@gmail.com>
Date:   Tue, 16 Apr 2019 17:19:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <60509a60-d0ea-d17f-8b79-e51c374717ba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

As it tuns out, I was able to create a new dkms.conf file which works on
my system. Below is  copy of the content from that file:

PACKAGE_NAME="rtlwifi-new"
PACKAGE_VERSION=0.6
MAKE="make -C $kernel_source_dir
M=$dkms_tree/$PACKAGE_NAME/$PACKAGE_VERSION/build"
CLEAN="make -C $kernel_source_dir clean"
BUILT_MODULE_NAME[0]="rtw88"
BUILT_MODULE_NAME[1]="rtwpci"
DEST_MODULE_LOCATION[0]="/updates"
DEST_MODULE_LOCATION[1]="/updates"
REMAKE_INITRD=no
AUTOINSTALL=yes

This also had the benefit of module signing by the version of dkms in
Ubuntu 19.04, so I am now also back on secure boot.

No action on your part is requested at this time.  Feel free to use the
new dkms.conf content if it is useful to you.

Regards,

David R. Bergstein

On 4/14/19 5:39 PM, David R. Bergstein wrote:
> Larry,
>
> Thanks for your prior assistance with the rtw88 module.  Since manually
> compiling and installing works correctly, I have been working to
> register the software in dkms, but am running into some difficulties. 
> Below are some snippets from a terminal session to illustrate the issue:
>
> udo dkms install rtlwifi-new/0.6
>
> Creating symlink /var/lib/dkms/rtlwifi-new/0.6/source ->
>                  /usr/src/rtlwifi-new-0.6
>
> DKMS: add completed.
>
> Kernel preparation unnecessary for this kernel.  Skipping...
>
> Building module:
> cleaning build area....(bad exit status: 2)
> make -j12 KERNELRELEASE=5.0.0-11-lowlatency -C
> /lib/modules/5.0.0-11-lowlatency/build
> M=/var/lib/dkms/rtlwifi-new/0.6/build....
> ERROR (dkms apport): binary package for rtlwifi-new: 0.6 not found
> Error!  Build of rtl_pci.ko failed for: 5.0.0-11-lowlatency (x86_64)
> Consult the make.log in the build directory
> /var/lib/dkms/rtlwifi-new/0.6/build/ for more information.
>
> Below is the make.log contents referenced above:
>
> DKMS make.log for rtlwifi-new-0.6 for kernel 5.0.0-11-lowlatency (x86_64)
> Sun 14 Apr 2019 05:25:37 PM EDT
> make: Entering directory '/usr/src/linux-headers-5.0.0-11-lowlatency'
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/main.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/mac80211.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/util.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/debug.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/tx.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rx.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/mac.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/phy.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/efuse.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/fw.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/ps.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/sec.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/regd.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822b.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822b_table.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822c.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw8822c_table.o
>   CC [M]  /var/lib/dkms/rtlwifi-new/0.6/build/pci.o
>   LD [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtwpci.o
>   LD [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw88.o
>   Building modules, stage 2.
>   MODPOST 2 modules
>   CC      /var/lib/dkms/rtlwifi-new/0.6/build/rtw88.mod.o
>   CC      /var/lib/dkms/rtlwifi-new/0.6/build/rtwpci.mod.o
>   LD [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtw88.ko
>   LD [M]  /var/lib/dkms/rtlwifi-new/0.6/build/rtwpci.ko
> make: Leaving directory '/usr/src/linux-headers-5.0.0-11-lowlatency'
>
> As you can see, the make log does not show any errors, which is baffling
> to me.  Any insight you have on resolving this issue would be appreciated.
>
> Sincerely,
>
> David R. Bergstein
>
>
