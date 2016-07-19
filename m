Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbcGSQif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 12:38:35 -0400
Message-ID: <1468946312.5661.2.camel@redhat.com> (sfid-20160719_183838_688308_D57E3027)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
From: Dan Williams <dcbw@redhat.com>
To: Christopher Williamson <home@chrisaw.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Jul 2016 11:38:32 -0500
In-Reply-To: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-07-19 at 12:06 -0400, Christopher Williamson wrote:
> Hi everyone!
> 
> I’ve just got myself a Viliv N5 and am trying to get the integrated
> Wifi chipset working on it.
> 
> I am able to see networks around me but any attempts to connect them
> appear to time out and fail.
> 
> I have filed a linux kernel bug related to this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=135421
> 
> I figured here may be a good place to ask about it and hopefully to
> get to the bottom of why it happens and how I can help to fix it.
> 
> Happy to provide any information which may be helpful! :)

Can you reload the driver stack:

rmmod libertas_sdio
rmmod libertas
modprobe libertas libertas_debug=0x251e7ff
modprobe libertas_sdio

and then reproduce the issue?  The debug info should dump to 'dmesg'
and may tell us what's going on.

Dan
