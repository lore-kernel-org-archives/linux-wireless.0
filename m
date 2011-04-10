Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58764 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1DJQ4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:56:03 -0400
Received: by wya21 with SMTP id 21so4216185wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 09:56:01 -0700 (PDT)
Message-ID: <4DA1E11D.6060703@gmail.com>
Date: Sun, 10 Apr 2011 18:55:57 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Questions about rt2800usb
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I noticed that rt2870sta includes a few USB IDs not found in rt2800usb, namely:
> 
> 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.
> 
> Any reasons why these should not be included in rt2800usb?

They were in the ralink driver imported into the kernel,
and later they were eliminated in recent versions of ralink drivers:
2010_0709_RT2870_Linux_STA_v2.4.0.1
2010_1215_RT3572_Linux_STA_v2.5.0.0.DPO
2011_0107_RT3070_RT3370_Linux_STA_v2.5.0.1_DPO


Only these four were meaningful, and they were included by me in rt2800usb.c:

<http://marc.info/?l=linux-wireless&m=130125079513964&w=2>
0x0411,0x016f de37cd49b5a54facef174cf34496919857436e8f MelCo(Buffalo) WLI-UC-G301N
0x050d,0x825b 12840c63b0679f7fab88ea1cc26b52db8b574ce7 Belkin F5D8055
0x050d,0x935a 705059a670f3af2b37695e82de0ee58e75e656ed Belkin F6D4050 v1
0x050d,0x935b 5d92fe3387d086fc2f10426fbdb6b86d6cce5a47 Belkin F6D4050 v2

I think 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14 can be despised,
unless they also be in the windows driver.
