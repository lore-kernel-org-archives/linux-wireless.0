Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59080 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2ITPbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 11:31:12 -0400
Received: by bkuw11 with SMTP id w11so300211bku.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 08:31:11 -0700 (PDT)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: artem.bityutskiy@linux.intel.com,
	Eric Dumazet <edumazet@google.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1348154831.31352.177.camel@edumazet-glaptop>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348151149.31352.109.camel@edumazet-glaptop>
	 <1348151876.2388.24.camel@sauron.fi.intel.com>
	 <1348152971.31352.140.camel@edumazet-glaptop>
	 (sfid-20120920_165616_301862_3EBAF30C)  <1348153522.4161.37.camel@jlt4.sipsolutions.net>
	 <1348154294.31352.165.camel@edumazet-glaptop>
	 (sfid-20120920_171820_134642_A4BA7EB1)  <1348154575.4161.39.camel@jlt4.sipsolutions.net>
	 <1348154831.31352.177.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Sep 2012 17:31:07 +0200
Message-ID: <1348155067.31352.183.camel@edumazet-glaptop> (sfid-20120920_173117_218865_1ABCC5A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 17:27 +0200, Eric Dumazet wrote:
> On Thu, 2012-09-20 at 17:22 +0200, Johannes Berg wrote:
> > On Thu, 2012-09-20 at 17:18 +0200, Eric Dumazet wrote:
> > 
> > > > Note I think the failing packets are dhcp packets, and connman seems to
> > > > use an AF_INET, SOCK_DGRAM, IPPROTO_UDP socket for those, and binds it
> > > > to the right device. I'd be quite surprised though if UDP code had
> > > > issues with paged Rx??
> > 
> > > You told me : socket(PF_PACKET, SOCK_RAW, htons(ETH_P_EAPOL))
> > > 
> > > So I looked at raw code.
> > 
> > and even found an issue. Artem wasn't really sure, but looking at his
> > information again it seems that the EAPOL packets (those on the raw
> > sockets) do go through, and then DHCP fails. In the printk he did for
> > me, I can see that the EAPOL packets are small enough to get pulled in
> > completely in iwlwifi, and the bigger DHCP packets (~600 bytes) only go
> > through if we linearize them.
> 
> OK, its a bug in UDP, I'll send a patch asap.

Oh well, false alarm.

Artem, could you send one capture of one such DHCP big packet ?

tcpdump -p -n -s 2000 -i wlanX -X


