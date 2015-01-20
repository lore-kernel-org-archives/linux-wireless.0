Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44924 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbbATJVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 04:21:14 -0500
Received: by mail-wi0-f176.google.com with SMTP id em10so3643966wid.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 01:21:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj984fjXUuRsNghr2Q4+397AS1TEO-K392YitUuZ5ztTF8iA@mail.gmail.com>
References: <54B97B96.4040903@darmstadt.freifunk.net>
	<1421658833-13311-1-git-send-email-michal.kazior@tieto.com>
	<54BDDB3B.3020902@candelatech.com>
	<CAEFj984fjXUuRsNghr2Q4+397AS1TEO-K392YitUuZ5ztTF8iA@mail.gmail.com>
Date: Tue, 20 Jan 2015 10:21:12 +0100
Message-ID: <CA+BoTQnjfsp3pjB4OyDvbqpQQ4TbYM+NHtTeNPCrgUJWfL-d+Q@mail.gmail.com> (sfid-20150120_102130_376143_59869A0D)
Subject: Re: [RFC/RFT] ath10k: enable IBSS in multi-vif
From: Michal Kazior <michal.kazior@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Martin Weinelt <martin@darmstadt.freifunk.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2015 at 10:14, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Experienced firmware crashed in 636 firmware immediately after
> bringing up the AP interface.
>
> The partial log is listed here:
[...]
> [  291.380000] ath10k_pci 0000:00:00.0: firmware register dump:
> [  291.380000] ath10k_pci 0000:00:00.0: [00]: 0x4100016C 0x00000000
> 0x009C4521 0x00000000
> [  291.390000] ath10k_pci 0000:00:00.0: [04]: 0x009C4521 0x00060330
> 0x00000019 0x00955A00
> [  291.400000] ath10k_pci 0000:00:00.0: [08]: 0x00046A4E 0x00000000
> 0x0040CC94 0x00000020
> [  291.410000] ath10k_pci 0000:00:00.0: [12]: 0x00000000 0x00000000
> 0x00958360 0x0095836B
> [  291.420000] ath10k_pci 0000:00:00.0: [16]: 0x809A0978 0x0040AD94
> 0x00439304 0x0040D074
> [  291.420000] ath10k_pci 0000:00:00.0: [20]: 0x0000FFFF 0x00000000
> 0x0041B618 0x00000000
> [  291.430000] ath10k_pci 0000:00:00.0: [24]: 0x809A0978 0x0040AD94
> 0x00439304 0x11A93B77
> [  291.440000] ath10k_pci 0000:00:00.0: [28]: 0x809AD1A2 0x0040ADE4
> 0x00439304 0x0043F68C
> [  291.450000] ath10k_pci 0000:00:00.0: [32]: 0x00000001 0x00000000
> 0x00000000 0x00430D74
> [  291.460000] ath10k_pci 0000:00:00.0: [36]: 0x00000000 0x00000000
> 0x00000000 0x00000000
> [  291.460000] ath10k_pci 0000:00:00.0: [40]: 0x00000000 0x00000000
> 0x000000AB 0x00412700
> [  291.470000] ath10k_pci 0000:00:00.0: [44]: 0x00439BB8 0x00000000
> 0x00000000 0x00400000
> [  291.480000] ath10k_pci 0000:00:00.0: [48]: 0x809AE0B4 0x0040AE04
> 0x00400000 0x0043F68C
> [  291.490000] ath10k_pci 0000:00:00.0: [52]: 0x00000001 0x00000000
> 0x004231F0 0x00400000
> [  291.500000] ath10k_pci 0000:00:00.0: [56]: 0x809AE17E 0x0040AE44
> 0x0040FE6C 0x0040D310

Yeah.. This is monitor vdev related crash (due to bridging, no?). I
haven't found a way around it.


Michał
