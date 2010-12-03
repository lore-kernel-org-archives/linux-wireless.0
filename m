Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0LCWt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 17:49:57 -0500
Received: by fxm20 with SMTP id 20so2692654fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 14:49:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101203202321.GA21937@monopoli.naic.edu>
References: <AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com>
	<20101126040742.GA5238@monopoli.naic.edu>
	<AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
	<20101130021911.GA18971@monopoli.naic.edu>
	<AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com>
	<20101202002234.GA30670@monopoli.naic.edu>
	<AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com>
	<20101203001052.GA16808@monopoli.naic.edu>
	<AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com>
	<AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com>
	<20101203202321.GA21937@monopoli.naic.edu>
Date: Fri, 3 Dec 2010 22:49:55 +0000
Message-ID: <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@googlemail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> >> But after removing the line: ap_scan=2
>> >> the association fails.
>> >> The log is in the second attachment.
>> >>
>> >> Also I have included in the 3rd attachement wpa_supplicant.log when
>> >> NetworkManager is used.
>>
>> > The failure and NM case are the same. There is still a problem with
>> > scanning. wpa_supplicant initiates a scan, and it appears to time out.
>> > Without scan results wpa_supplicant is not able to select an
>> > appropriate AP.
>> >
>> > Is the driver reporting any scanning issues in dmesg while
>> > wpa_supplicant is running?
>
> In dmesg there is:
> ADDRCONF(NETDEV_UP): eth1: link is not ready
>
> and on standard error:
> ioctl[SIOCSIWENCODEEXT]: Invalid argument

Those are expected.

I'm at a loss. I've looked at the wpa_supplicant code, and had another
look at the driver. The scan should be a plain wildcard scan - which
you've identified works.

Does setting scan_ssid=1 in the wpa_supplicant network block change
the behaviour? That's usually only necessary for hidden SSIDs - but
I'd like to know if the scan succeeds in this case.


Dave.
