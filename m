Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out15.sjc.mx.trendmicro.com ([216.99.131.72]:52421 "EHLO
	out15.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474AbbGFTEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 15:04:33 -0400
Received: from relay04.sjc.mx.trendmicro.com (unknown [10.30.239.26])
	by out15.sjc.mx.trendmicro.com (Postfix) with ESMTP id 4578D981181
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2015 19:04:33 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay04.sjc.mx.trendmicro.com (Postfix) with ESMTP id AC3F298041B
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2015 19:04:32 +0000 (UTC)
Received: from unknown (HELO [192.168.5.9]) (br1@[188.85.29.34])
          (envelope-sender <br1@thinktube.com>)
          by 111.68.225.247 (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 6 Jul 2015 19:04:31 -0000
Message-ID: <559AD13B.7030105@thinktube.com> (sfid-20150706_210437_394761_CD6A5F22)
Date: Mon, 06 Jul 2015 20:04:27 +0100
From: Bruno Randolf <br1@thinktube.com>
MIME-Version: 1.0
To: Richard Palethorpe <richard@lm-technologies.com>,
	Taehee Yoo <ap420073@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mesh support on rtl8192cu
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>	<55965CF8.20208@thinktube.com>	<CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com> <CAFSTUk6u6rNF1njVBMFT4VAKPZ0Y6BvHB3mJEu7H7oM3tma5tQ@mail.gmail.com>
In-Reply-To: <CAFSTUk6u6rNF1njVBMFT4VAKPZ0Y6BvHB3mJEu7H7oM3tma5tQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2015 11:46 AM, Richard Palethorpe wrote:
> Bruno, that surprises me somewhat because I have got IBSS mode to work
> on kernel 4.0+. Are you using a slightly older kernel?

I'm using kernel 3.18 with wireless drivers from backports in OpenWRT
CC, so it should be pretty recent...

I wonder to what level did you verify the IBSS operation?

I did get it to basically work as well, sometimes it works well, but
sometimes I get a packet loss of about 15-20% and outages of
connectivity for a while. This happens not always immediately, but
reproducibly after some time. Try pinging for an hour or so...?

I traced it down to ARP replies being apparently "sent" on the device
(tcpdump shows it locally) but they don't make it onto the "air"...

If you or anyone else can confirm ad-hoc mode really works, on some
version of the driver, I'll start to investigate more.

bruno

