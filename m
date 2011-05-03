Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1ECG46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 02:56:58 -0400
Received: by pzk9 with SMTP id 9so3371703pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 23:56:57 -0700 (PDT)
Message-ID: <4DBFA735.6050901@gmail.com> (sfid-20110503_085706_028808_FB7241E6)
Date: Tue, 03 May 2011 16:56:53 +1000
From: Peizhao Hu <peizhao.research@gmail.com>
Reply-To: peizhao.research@gmail.com
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Russell Senior <seniorr@aracnet.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
References: <861v0igqhn.fsf@coulee.tdb.com> <BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>
In-Reply-To: <BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Would the issue I posted help to resolve this?
http://www.mail-archive.com/openwrt-users@lists.openwrt.org/msg01001.html

regards;

Peizhao


On 03/05/11 16:18, Adrian Chadd wrote:
> Well, I see the same on FreeBSD/MIPS whenever an Atheros device is
> fondled incorrectly. Either because the chip isn't yet fully awake or
> the register plainly doesn't exist.
>
> See if you can add some debugging in ath5k_hw_reset_tx_queue() to see
> which register is being read/written before the PCI bus error occurs.
>
> I have that hardware (routerstation/rspro) and the CM-9 card but I
> don't currently have any spare time to run it up and test, sorry.
>
>
> Adrian
>
> On 2 May 2011 03:39, Russell Senior<seniorr@aracnet.com>  wrote:
>> Recently trying to abandon madwifi for good on some embedded devices
>> with OpenWrt, encountered kernel panics.  Same radio on an x86
>> platform (Soekris net4826), no kernel panic.  Different atheros radio,
>> no kernel panic.  Tried two different MIPS boards (Netgear WGT634U and
>> Ubiquiti RouterStation), both panic'd.
>>
>> Netgear WGT634U:  http://pastebin.ca/2051127
>> Ubiquiti RouterStation: http://pastebin.ca/2052610
>>
>> Both cases were firmwares built from r26771 of OpenWrt, and both seem
>> to have panic'd from hostapd.  While researching this, I encountered a
>> similar report from last June:
>>
>>   http://www.mail-archive.com/openwrt-users@lists.openwrt.org/msg01001.html
>>   http://www.spinics.net/lists/linux-wireless/msg52502.html
>>
>> Another person reported some issues with the CM9 earlier this year in
>> client mode:
>>
>>   http://permalink.gmane.org/gmane.linux.drivers.ath5k.devel/4722
>>
>> I am happy to do some leg work on getting this fixed, if someone can
>> provide some guidance.  Thanks!
>>
>>
>> --
>> Russell Senior         ``I have nine fingers; you have ten.''
>> seniorr@aracnet.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
