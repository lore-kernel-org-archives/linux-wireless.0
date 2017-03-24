Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35041 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdCXPDS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 11:03:18 -0400
Received: by mail-wr0-f195.google.com with SMTP id u108so798071wrb.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Mar 2017 08:01:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: ath10k@lists.infradead.org,
        ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Adrian Chadd <adrian@freebsd.org>
Subject: Re: QCA9984 bmi identification failure
Date: Fri, 24 Mar 2017 16:01:42 +0100
Message-ID: <3143301.IOZImBPhRt@debian64> (sfid-20170324_160323_344521_AAA42767)
In-Reply-To: <4960795b-028f-27b1-8bdf-6c9fb2242f5f@dd-wrt.com>
References: <3243718.FYinmXYgr7@debian64> <4960795b-028f-27b1-8bdf-6c9fb2242f5f@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 24, 2017 11:09:03 AM CET Sebastian Gottschall wrote:
> i have a r7800 running. consider to use the board.bin file which is=20
> stored in flash memory of the r7800.
Well, this is a bit beside the point. But what makes you think that=20
what is stored in the flash memory of R7800 is the "board.bin"?=20
I know that Netgear provided a myriad of different board data files
with in there GPL drop:

Here's a link:
<https://github.com/paul-chambers/netgear-r7800/tree/master/git_home/madwif=
i-11n.git/halphy_tools/host/eepromUtil/release_qca9984/hw1>

So, does the data in your flash matches any of those files 1:1 or not?

(Note: From what I know, it's the caldata that's in the flash.=20
caldata =E2=89=88 cal+board. But I'm asking why ath10k's bmi identification
isn't working for those chips right now. And judging from your logs,
you are using probably a similar WA to the=20
936-ath10k_skip_otp_check.patch out of necessity as well.)

> there are 2 stored for both cards. you need to patch ath10k to use=20
> different board.bin files for each card.
Exactly. Why do you (or anyone for that matter) need to patch ath10k?
The driver is supposed to support the QCA9984 out of the box, right?

And I know, that the bmi identification is supposed to work, as
somebody posted the following log:
<http://lists.infradead.org/pipermail/lede-dev/2016-December/004987.html>

[  379.392210] ath10k_pci 0002:01:00.0: boot upload otp to 0x1234 len 9000 =
for board id
[  379.399945] ath10k_pci 0002:01:00.0: bmi fast download address 0x1234 bu=
ffer 0xe1676038 length 9000
[  379.408977] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x1234
[  379.415603] ath10k_pci 0002:01:00.0: bmi lz data buffer 0xe1676038 lengt=
h 9000
[  379.451626] ath10k_pci 0002:01:00.0: bmi lz stream start address 0x0
[  379.457985] ath10k_pci 0002:01:00.0: bmi execute address 0x1234 param 0x=
10
[  380.857006] ath10k_pci 0002:01:00.0: bmi execute result 0x400
[  380.862749] ath10k_pci 0002:01:00.0: boot get otp board id result 0x0000=
0400 board_id 1 chip_id 0
[  380.871603] ath10k_pci 0002:01:00.0: boot using board name 'bus=3Dpci,bm=
i-chip-id=3D0,bmi-board-id=3D1'
[  380.880468] ath10k_pci 0002:01:00.0: board name
[  380.884999] ath10k_pci 0002:01:00.0: 00000000: 62 75 73 3d 70 63 69 2c 6=
2 6d 69 2d 63 68 69 70  bus=3Dpci,bmi-chip
[  380.895159] ath10k_pci 0002:01:00.0: 00000010: 2d 69 64 3d 30 2c 62 6d 6=
9 2d 62 6f 61 72 64 2d  -id=3D0,bmi-board-
[  380.905317] ath10k_pci 0002:01:00.0: 00000020: 69 64 3d 31              =
                        id=3D1
[  380.914436] ath10k_pci 0002:01:00.0: boot found match for name 'bus=3Dpc=
i,bmi-chip-id=3D0,bmi-board-id=3D1'
[  380.923640] ath10k_pci 0002:01:00.0: boot found board data for 'bus=3Dpc=
i,bmi-chip-id=3D0,bmi-board-id=3D1'
[  380.932845] ath10k_pci 0002:01:00.0: using board api 2
=2E..

The board name for the QCA9984 is supposed to look like
"'bus=3Dpci,bmi-chip-id=3D0,bmi-board-id=3D1'"

and not like (from your log):
> bus=3Dpci,vendor=3D168c,device=3D0046,subsystem-vendor=3D168c,subsystem-d=
evice=3Dcafe=20
> from ath10k/QCA9984/hw1.0/board-2.bin

> the failed to fetch board data error is normal.=20
I don't think it is. I think it's a regression.

Thanks,
Christian
