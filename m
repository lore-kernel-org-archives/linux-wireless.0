Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51168 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbeEVIM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:12:57 -0400
Message-ID: <1526976774.6787.7.camel@sipsolutions.net> (sfid-20180522_101324_267813_A300563F)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 10:12:54 +0200
In-Reply-To: <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com> (sfid-20180518_184751_575479_93289B63)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         (sfid-20180518_184751_575479_93289B63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

> Just FYI, there's definitely something funny with the scanning code:
> 
> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush
> BSS 10:c3:7b:54:74:d4(on wlp2s0)
> 	last seen: 274.815s [boottime]
> 	freq: 5765
> 	beacon interval: 100 TUs
> 	signal: -35.00 dBm
> 	last seen: 349 ms ago
> 	Information elements from Probe Response frame:
> 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00

This is already rather strange to start with. Can you provide a sniffer
capture of this situation?

Thing is - the all-zero-bytes there points to using hidden SSID with a
length of 9 characters, BUT
 * "myssid" is just 6 characters long - or did you edit that?
 * normally the zeroed-out SSID isn't transmitted in a *probe response*
   but only in beacons

> Then if I try:
> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush ssid myssid
> BSS 10:c3:7b:54:74:d4(on wlp2s0)
> 	last seen: 319.667s [boottime]
> 	freq: 5765
> 	beacon interval: 100 TUs
> 	signal: -42.00 dBm
> 	last seen: 350 ms ago
> 	Information elements from Probe Response frame:
> 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
> ....
> BSS 10:c3:7b:54:74:d4(on wlp2s0)
> 	last seen: 319.662s [boottime]
> 	freq: 5765
> 	beacon interval: 100 TUs
> 	signal: -37.00 dBm
> 	last seen: 355 ms ago
> 	Information elements from Probe Response frame:
> 	SSID: myssid
> 
> Shouldn't the second scan give a single result from that one BSS?

Well, depends what the AP sends you really. The "last seen" doesn't
indicate that it's not flushed but rather that you got it again, so
without seeing the sniffer I don't think we can really say what's going
on.

johannes
