Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52211 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJCKEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 06:04:22 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so1561568wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2014 03:04:21 -0700 (PDT)
Received: from [192.168.178.115] (g231111229.adsl.alicedsl.de. [92.231.111.229])
        by mx.google.com with ESMTPSA id cz3sm7458007wjb.23.2014.10.03.03.04.19
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 03 Oct 2014 03:04:20 -0700 (PDT)
Date: Fri, 03 Oct 2014 12:04:09 +0200
Subject: Frame Injection with NL80211_CMD_FRAME is failing
From: Hakan =?UTF-8?B?Q2/Fn2t1bg==?= <hakanberlin@gmail.com>
To: <linux-wireless@vger.kernel.org>
Message-ID: <D0544139.F308%hakanberlin@gmail.com> (sfid-20141003_120425_578649_1C7AE4AD)
Mime-version: 1.0
Content-type: text/plain;
	charset="EUC-KR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

For some time I am playing around with tools like scapy, senf, lorcon etc.
Which allow to receive and construct frames in user-space and send them
with
pcap or raw sockets. I am trying to achieve the injection part with
NL80211_CMD_FRAME. According to the description, only management frames are
supported by this command. Am I right ?

I put some printks into nl80211.c and mlme.c to follow the transmission
part
and to understand where my commands are failing.
I©öve put my interface into master mode (NL80211_IFTYPE_AP) in order pass
the
checks in cfg80211. When I try to send down a beacon frame or another
management frame I got an error from cfg80211_mlme_mgmt_tx in mlme.c.
rdev_mgmt_tx returns an error code. How can I figure out why my frame is
not
send down on the wiphy ?

By the way, why is CMD_FRAME only restricted to management frames ?


Regards,
Hakan


