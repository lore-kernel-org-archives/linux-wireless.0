Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56074 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3JHP4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 11:56:47 -0400
Received: from [192.168.2.102] ([93.218.71.155]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MZCQ8-1VD8j31xE4-00L0It for
 <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 17:56:45 +0200
Message-ID: <52542B3B.1020703@rempel-privat.de> (sfid-20131008_175650_231060_89DA0315)
Date: Tue, 08 Oct 2013 17:56:43 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Matt Chen <machen@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: WIFI P2P ping doesn't work.
References: <CALx5=V_OdHRJsourv2Hiykg-shyrisdrNnzD1qvpjAWR2iQyfg@mail.gmail.com> <CALx5=V8AJr5FTWkbT+s79kbPX2NftmbC74HgH3V5TEUj0gvdpA@mail.gmail.com>
In-Reply-To: <CALx5=V8AJr5FTWkbT+s79kbPX2NftmbC74HgH3V5TEUj0gvdpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

no suggestions. I was able to reproduce same issue yesterday on
ath9k_htc. But currently no time to digg in it.


Am 08.10.2013 17:41, schrieb Matt Chen:
> No one has any suggestion and comment ?
> 
> 2013/10/8 Matt Chen <machen@suse.com>:
>> Hi list,
>>
>> I am running the v3.12-rc3 and using Atheros AR9485 with ath9k. My
>> wpa_supplicant is from git://w1.fi/srv/git/hostap.git in master branch
>> with most recent commit.
>>
>> The my_p2p_supplicant.conf for my wpa_supplicant is :
>> =======================================
>> ctrl=/var/run/wpa_supplicant
>> update_config=1
>>
>> device_name=HP GO
>> device_type=1-0050F204-2
>>
>> p2p_go_ht40=1
>>
>> =========================================
>>
>> I run "wpa_supplicant -i wlan0 -f my_p2p_supplicant.conf -Dnl80211
>> -ddt -f /var/log/wpa_supplicant -B
>>
>> I use wpa_cli to work on P2P. So here goes my case:
>>
>> M#1
>> p2p_find
>> p2p_stop
>> p2p_peers
>> p2p_connect [M#2 MAC ADDRESS] pbc go_intent=7
>>
>> M#2
>> p2p_find
>> p2p_stop
>> p2p_peers
>> p2p_connect [M#1 MAC ADDRESS] pbc
>>
>>
>> Then I can find the M#1 become the P0 GO mode and M#2 become station
>> mode. And each status is completed. But after that, I set each machine
>> with a static IP such as 192.168.5.10 and 192.168.5.11 manually. I am
>> not able to ping each IP.
>>
>> Is there anything I am doing wrong ?
>>
>> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Regards,
Oleksij
