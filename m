Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38025 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaJQOw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 10:52:26 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so2330902wid.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 07:52:25 -0700 (PDT)
Received: from [194.95.175.89] (edu175089.fhi-fokus.de. [194.95.175.89])
        by mx.google.com with ESMTPSA id l5sm2352173wif.3.2014.10.17.07.52.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 17 Oct 2014 07:52:24 -0700 (PDT)
Date: Fri, 17 Oct 2014 16:52:15 +0200
Subject: Re: Frame Injection with NL80211_CMD_FRAME is failing (SOLVED)
From: Hakan =?UTF-8?B?Q2/Fn2t1bg==?= <hakanberlin@gmail.com>
To: <linux-wireless@vger.kernel.org>
Message-ID: <D066F86F.F9DA%hakanberlin@gmail.com> (sfid-20141017_165230_146591_669F478E)
Mime-version: 1.0
Content-type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I found the problem. There is a check in /net/mac80211/cfg.c

!rcu_access_pointer(sdata->bss->beacon))

I guess this related to beaconing. If it is not configured, off-channel is
required in any case.

If you put the interface into AP mode and try to send frames with
NL80211_CMD_FRAME you have to set the OFFCHANNEL_TX_OK flag in any case !!!


Right now I am facing the problem of not getting probe-requests delivered
to my master mode interface through NL80211_CMD_REGISTER_FRAME. It works
only if I start an additional monitor interface on the same card. Any clue
what to do to enable frame delivery to the AP interface without a monitor
interface.


Kind Regards,
Hakan


Am 03.10.14 12:04 schrieb "Hakan Coşkun" unter <hakanberlin@gmail.com>:

>Hi,
>
>For some time I am playing around with tools like scapy, senf, lorcon etc.
>Which allow to receive and construct frames in user-space and send them
>with
>pcap or raw sockets. I am trying to achieve the injection part with
>NL80211_CMD_FRAME. According to the description, only management frames
>are
>supported by this command. Am I right ?
>
>I put some printks into nl80211.c and mlme.c to follow the transmission
>part
>and to understand where my commands are failing.
>I¹ve put my interface into master mode (NL80211_IFTYPE_AP) in order pass
>the
>checks in cfg80211. When I try to send down a beacon frame or another
>management frame I got an error from cfg80211_mlme_mgmt_tx in mlme.c.
>rdev_mgmt_tx returns an error code. How can I figure out why my frame is
>not
>send down on the wiphy ?
>
>By the way, why is CMD_FRAME only restricted to management frames ?
>
>
>Regards,
>Hakan
>


