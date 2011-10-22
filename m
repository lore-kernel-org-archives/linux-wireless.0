Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:59464 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752280Ab1JVHVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 03:21:47 -0400
Date: Sat, 22 Oct 2011 09:22:15 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111022072215.GA2524@ecki> (sfid-20111022_092151_109136_09821BFC)
References: <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
 <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
 <20111015093902.GA23520@ecki>
 <CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
 <20111018064459.GA1442@ecki>
 <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
 <20111021102221.GA1463@ecki.lan>
 <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
 <20111021202038.GA1523@ecki.lan>
 <CAJ-Vmonu-75rtOyyqP7aWNA5NvQ7XW+0YB-G7N5gF3tS5E0EaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmonu-75rtOyyqP7aWNA5NvQ7XW+0YB-G7N5gF3tS5E0EaA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Oct 22, 2011 at 08:47:33AM +0800, Adrian Chadd wrote:
> 
> At this point I'd really suggest whacking other devices into the slot
> to see if they generate the same kind of behaviour.

Looks like you had it right from the start. After unloading the jme
module [*1*] I cannot reproduce the IRQ storm any more. From
looking at dmesg it should have been obvious, since it also gets
IRQ 17 assigned. I don't know how I missed that, I was sure I had
checked.

Sorry guys, for most likely wasting your time. And thanks for your
patience.

Best,
Clemens

[*1*]

$ lspci
06:00.5 Ethernet controller: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller (rev 03))

$ dmesg|grep -i jme
[    6.160187] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    6.160278] jme 0000:06:00.5: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.160305] jme 0000:06:00.5: setting latency timer to 64
[    6.161154] jme 0000:06:00.5: eth0: JMC250 Gigabit Ethernet chiprev:23 pcirev:3 macaddr:bc:ae:c5:2f:91:47
[   18.354697] jme 0000:06:00.5: PCI INT A disabled
