Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36451 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2DNVgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 17:36:16 -0400
Received: by iagz16 with SMTP id z16so5770397iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2012 14:36:16 -0700 (PDT)
Message-ID: <4F89EDCC.7080302@lwfinger.net> (sfid-20120414_233620_247933_867F474E)
Date: Sat, 14 Apr 2012 16:36:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c put back duplicate
 id
References: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/2012 04:00 PM, Xose Vazquez Perez wrote:
> put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:
>
> K7SF5D7050A ver 2xxx is rt2500
> K7SF5D7050B ver 3xxx is rt73
>
> <http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>
>
> Signed-off-by: Xose Vazquez Perez<xose.vazquez@gmail.com>

I did a quick look at the rt2500 driver and did not see any code that detects 
what version chip is being read. If it is possible to determine if it is ver 
2xxx and not 3xxx, then the probe routine should do that and return an error if 
the wrong driver is being loaded. A similar situation arises in the Realtek PCI 
devices. In that case, it is a PCI revision that allows a driver to reject the 
wrong hardware.

Larry

