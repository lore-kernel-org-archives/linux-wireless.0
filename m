Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34086 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbbG0Xz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 19:55:28 -0400
Received: by lafd3 with SMTP id d3so48215261laf.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 16:55:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
 <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com> <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 28 Jul 2015 01:55:08 +0200
Message-ID: <CAFBinCCzTTdkENDZ5BVPnSqXV7uFUtBabAYFuT4-sd2M=KVxLg@mail.gmail.com> (sfid-20150728_015532_359302_154D63B8)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 1:50 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> is it never getting any readings before your patch? NF Readings all
> look empty...
Yes, looks like it. Unfortunately I haven't saved a complete kernel
log (with ath9k debug level = 0x00004449) but only a few parts. Here
are the interesting bits:
<7>[ 449.746679] ath: phy1: NF calibrated [ctl] [chain 0] is -106
<7>[ 449.746697] ath: phy1: NF[0] (-106) > MAX (-110), correcting to MAX
<7>[ 449.746714] ath: phy1: NF calibrated [ctl] [chain 1] is -90
<7>[ 449.746731] ath: phy1: NF[1] (-90) > MAX (-110), correcting to MAX
<7>[ 449.746748] ath: phy1: NF calibrated [ext] [chain 0] is -103
<7>[ 449.746765] ath: phy1: NF[3] (-103) > MAX (-110), correcting to MAX
<7>[ 449.746781] ath: phy1: NF calibrated [ext] [chain 1] is -86
<7>[ 449.746798] ath: phy1: NF[4] (-86) > MAX (-110), correcting to MAX
<7>[ 449.746878] ath: phy1: Calibration @37407 finished: long ani, caldone: true

I'd assume (because I don't know the ath9k code) that ath9k simply
ignores NF readings that are "out of range" (as suggested by those
messages).


Regards,
Martin
