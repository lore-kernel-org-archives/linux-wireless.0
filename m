Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46835 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbaAJRCT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 12:02:19 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: "'Andreas Fenkart'" <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 10 Jan 2014 09:02:10 -0800
Subject: RE: mwifiex wowlan not working
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59510D9F010D4@SC-VEXCH1.marvell.com> (sfid-20140110_180222_336167_28B6BCD2)
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
In-Reply-To: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

>
> these fail:
> 
> iw phy0 wowlan enable magic-packet
> etherwake -i wlan0 5C:F8:A1:15:1B:0B
> wakeonlan 5C:F8:A1:15:1B:0B
> 

It works for magic-packet, only if the packet contains device's(Marvell) MAC address and received through wireless interface.
Are you generating magic packet on different device connected wirelessly?
Is 5C:F8:A1:15:1B:0B MAC of Marvell device?

> wake-on RX packets with TCP destination port 22
> iw phy0 wowlan enable patterns 44+16
> <hit random keys in ssh session, established before sleep>

This could be a setup issue. Connection might have lost.
Can you please confirm using TCPDUMP,sniffer etc. if TCP packets are actually transmitted by remote device?

Regards,
Amitkumar Karwar
