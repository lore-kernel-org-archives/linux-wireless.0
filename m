Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39411 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1FKR53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 13:57:29 -0400
Date: Sat, 11 Jun 2011 19:57:21 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Can iperf work with no qos? (TCP mode)
Message-ID: <20110611195721.735dcf4c@maggie> (sfid-20110611_195732_284086_94E81ED5)
In-Reply-To: <BANLkTimaUBe6kszbvSeSPTXR6m1t8C8O-A@mail.gmail.com>
References: <BANLkTimaUBe6kszbvSeSPTXR6m1t8C8O-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 11 Jun 2011 19:47:31 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> I can not get any results when trying to use iperf in TCP mode with
> driver not supporting qos.
> 
> Is this expected? Does iperf fill connection with so many packets,
> it's not possible to get response from the iperf receiver? Should not
> Linux somehow schedule packet to allow bi-direction communication,
> even on really filled connection?

iperf will only fill the best effort queue. At least that's what it did
last time when I looked into the code.
You can verify that with b43's ring statistics.
