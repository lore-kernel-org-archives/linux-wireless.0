Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45924 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab3JHPlO (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 8 Oct 2013 11:41:14 -0400
Received: by mail-ie0-f170.google.com with SMTP id x13so20545039ief.29
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 08:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V_OdHRJsourv2Hiykg-shyrisdrNnzD1qvpjAWR2iQyfg@mail.gmail.com>
References: <CALx5=V_OdHRJsourv2Hiykg-shyrisdrNnzD1qvpjAWR2iQyfg@mail.gmail.com>
Date: Tue, 8 Oct 2013 23:41:07 +0800
Message-ID: <CALx5=V8AJr5FTWkbT+s79kbPX2NftmbC74HgH3V5TEUj0gvdpA@mail.gmail.com> (sfid-20131008_174117_119108_011C12B9)
Subject: Re: WIFI P2P ping doesn't work.
From: Matt Chen <machen@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No one has any suggestion and comment ?

2013/10/8 Matt Chen <machen@suse.com>:
> Hi list,
>
> I am running the v3.12-rc3 and using Atheros AR9485 with ath9k. My
> wpa_supplicant is from git://w1.fi/srv/git/hostap.git in master branch
> with most recent commit.
>
> The my_p2p_supplicant.conf for my wpa_supplicant is :
> =======================================
> ctrl=/var/run/wpa_supplicant
> update_config=1
>
> device_name=HP GO
> device_type=1-0050F204-2
>
> p2p_go_ht40=1
>
> =========================================
>
> I run "wpa_supplicant -i wlan0 -f my_p2p_supplicant.conf -Dnl80211
> -ddt -f /var/log/wpa_supplicant -B
>
> I use wpa_cli to work on P2P. So here goes my case:
>
> M#1
> p2p_find
> p2p_stop
> p2p_peers
> p2p_connect [M#2 MAC ADDRESS] pbc go_intent=7
>
> M#2
> p2p_find
> p2p_stop
> p2p_peers
> p2p_connect [M#1 MAC ADDRESS] pbc
>
>
> Then I can find the M#1 become the P0 GO mode and M#2 become station
> mode. And each status is completed. But after that, I set each machine
> with a static IP such as 192.168.5.10 and 192.168.5.11 manually. I am
> not able to ping each IP.
>
> Is there anything I am doing wrong ?
>
> Thank you.
