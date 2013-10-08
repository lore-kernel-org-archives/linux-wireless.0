Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57746 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JHQDb (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 8 Oct 2013 12:03:31 -0400
Received: by mail-ie0-f171.google.com with SMTP id at1so19606588iec.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 09:03:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52542B3B.1020703@rempel-privat.de>
References: <CALx5=V_OdHRJsourv2Hiykg-shyrisdrNnzD1qvpjAWR2iQyfg@mail.gmail.com>
	<CALx5=V8AJr5FTWkbT+s79kbPX2NftmbC74HgH3V5TEUj0gvdpA@mail.gmail.com>
	<52542B3B.1020703@rempel-privat.de>
Date: Wed, 9 Oct 2013 00:03:21 +0800
Message-ID: <CALx5=V_6fXBxE2z3wOu2DYnNKkA7sHOeqz6bxUWw9RGEQEJsnw@mail.gmail.com> (sfid-20131008_180335_201093_60A3611D)
Subject: Re: WIFI P2P ping doesn't work.
From: Matt Chen <machen@suse.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

Thanks for the info anyway. :)

2013/10/8 Oleksij Rempel <linux@rempel-privat.de>:
> Hi Matt,
>
> no suggestions. I was able to reproduce same issue yesterday on
> ath9k_htc. But currently no time to digg in it.
>
>
> Am 08.10.2013 17:41, schrieb Matt Chen:
>> No one has any suggestion and comment ?
>>
>> 2013/10/8 Matt Chen <machen@suse.com>:
>>> Hi list,
>>>
>>> I am running the v3.12-rc3 and using Atheros AR9485 with ath9k. My
>>> wpa_supplicant is from git://w1.fi/srv/git/hostap.git in master branch
>>> with most recent commit.
>>>
>>> The my_p2p_supplicant.conf for my wpa_supplicant is :
>>> =======================================
>>> ctrl=/var/run/wpa_supplicant
>>> update_config=1
>>>
>>> device_name=HP GO
>>> device_type=1-0050F204-2
>>>
>>> p2p_go_ht40=1
>>>
>>> =========================================
>>>
>>> I run "wpa_supplicant -i wlan0 -f my_p2p_supplicant.conf -Dnl80211
>>> -ddt -f /var/log/wpa_supplicant -B
>>>
>>> I use wpa_cli to work on P2P. So here goes my case:
>>>
>>> M#1
>>> p2p_find
>>> p2p_stop
>>> p2p_peers
>>> p2p_connect [M#2 MAC ADDRESS] pbc go_intent=7
>>>
>>> M#2
>>> p2p_find
>>> p2p_stop
>>> p2p_peers
>>> p2p_connect [M#1 MAC ADDRESS] pbc
>>>
>>>
>>> Then I can find the M#1 become the P0 GO mode and M#2 become station
>>> mode. And each status is completed. But after that, I set each machine
>>> with a static IP such as 192.168.5.10 and 192.168.5.11 manually. I am
>>> not able to ping each IP.
>>>
>>> Is there anything I am doing wrong ?
>>>
>>> Thank you.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Regards,
> Oleksij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
