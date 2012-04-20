Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2DTSAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 14:00:08 -0400
Received: by bkcik5 with SMTP id ik5so7393905bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 11:00:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170 - monitor mode TP drop
Date: Fri, 20 Apr 2012 19:59:54 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
In-Reply-To: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204201959.56495.chunkeey@googlemail.com> (sfid-20120420_200015_373267_26677699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 April 2012 09:41:15 Janusz Dziedzic wrote:
> Hello,
> 
> I am using newest compat-wireless + newest-firmware.
> Next I setup monitor mode + channel and run wireshark - I do that to
> record TCP flow on the channel.
> 
> Before that I had TCP throughput about 30Mbit/s and after run
> wireshark I see TP drop - about 3Mbit/s (after setting monitor mode).
> This TP is between AP and other STA on the same channel.
> 
> Should I set/check something more to not see this TP drop?

Well, I don't know how you exactly setup the mode. But If
the monitor interface is set to PROMISC, then it's likely
that the hardware will be set into a special "sniffer"
operation mode. This mode is great if you are interested in
frames with bad PLCPs and FCS but it is not so great for
throughput because the rx filter won't filter anymore and
the tons of garbage that usually is dropped early on gets
passed to the host and on it's way it competes for FIFO
resources with the data. 

(One more thing: Isn't it possible to get the TCP flow,
from the "ethernet" (as ifconfig calls it) interface of
the wlan device as well?)

Regards,
	Christian
