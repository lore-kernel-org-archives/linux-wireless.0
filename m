Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34378 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755496AbdC1QTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 12:19:22 -0400
Received: by mail-wr0-f196.google.com with SMTP id w43so20816852wrb.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 09:19:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: ath10k@lists.infradead.org,
        ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Adrian Chadd <adrian@freebsd.org>,
        "K.Mani" <sailormani@gmail.com>
Subject: Re: QCA9984 bmi identification failure
Date: Tue, 28 Mar 2017 18:19:03 +0200
Message-ID: <3137484.Xc0vILIBar@debian64> (sfid-20170328_182304_807431_36CF553E)
In-Reply-To: <c4add4e6-a6ba-bc17-0543-01292d4371e4@dd-wrt.com>
References: <3243718.FYinmXYgr7@debian64> <1843566.sGKvOoxMzK@debian64> <c4add4e6-a6ba-bc17-0543-01292d4371e4@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 27, 2017 1:33:54 PM CEST Sebastian Gottschall wrote:
> i dont know how to prove you that the firmware format is identical without
> simply showing you the hexdump.
We sort of know what is encoded in these calibration files in the flash and
in the board files. I've told you about the BoardData Files on github. If 
you look into the directory, you'll notice that for each of the board.bin
files there, there's a .txt with the same name:

e.g.:
<https://github.com/paul-chambers/netgear-r7800/blob/master/git_home/madwifi-11n.git/halphy_tools/host/eepromUtil/release_qca9984/hw1/boardData_QCA9984_CUS238_5G_v1_003.txt>

You can use the identifiers from the file and compare the data from the flash
and the boardData file, you'll notice that they are differences. And the
difference is what caused all these problems. We ran into this last year
with the IPQ40XX. You can read all about it on the ath10k ML: This was one
of the threads:
<https://www.mail-archive.com/ath10k@lists.infradead.org/msg06154.html>

> > which is what I said in the response as well. we both knew that
> > (from the beginning). If you want you can go on about it:
> > Please do. However, you should provide some data to back up your
> > claims and statements (logs, links to code or patches are fine I think).
> > Furthermore, let's keep the discussion civil and not go off on a
> > tangent and start a pissing contest. And finally, let's not forget
> > that the discussion is about the "QCA9984 bmi identification failure".
> ahm. sorry. we stop here. [...]
> i do not claim anything and i dont have you proof anything. [...]
> its up to you if you believe me or not.

Ok. Then let's stop here.

> > If so, then there's the Aerohive HiveAP 121.
> > <https://github.com/riptidewave93/LEDE-HiveAP-121>. It has an AR934x SoC
> > and the internal WMAC is storing its calibration data in the SoC's OTP area.
> > The device is supported by ath9k. The device does have a wifi-cal/art
> > partition but it was empty.
> need to take a look into a flash memory dump so see if i find the 
> calibration data. the partition you see is created by lede as 
> preconfigured layout.
Well, if you are still interested and want to take a look at it.
I can ask Chris Blake, if he's willing to sent the complete flashdump
of the Aerohive HiveAP 121. It's one of those enterprise APs, it has 
a NAND and NOR chip, so from what I remember the image is like 20MiB+
zipped.

Thanks,
Christian
