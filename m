Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60673 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2DQPNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 11:13:09 -0400
Received: by mail-we0-f174.google.com with SMTP id x9so4101734wej.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 08:13:09 -0700 (PDT)
Message-ID: <4F8D8882.3070004@gmail.com> (sfid-20120417_171314_170131_21AF3C28)
Date: Tue, 17 Apr 2012 17:13:06 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c put back duplicate
 id
References: <1334437201-12737-1-git-send-email-xose.vazquez@gmail.com> <4F89EDCC.7080302@lwfinger.net>
In-Reply-To: <4F89EDCC.7080302@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/2012 11:36 PM, Larry Finger wrote:

> On 04/14/2012 04:00 PM, Xose Vazquez Perez wrote:
>> put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:
>>
>> K7SF5D7050A ver 2xxx is rt2500
>> K7SF5D7050B ver 3xxx is rt73
>>
>> <http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>
>>
>> Signed-off-by: Xose Vazquez Perez<xose.vazquez@gmail.com>

> I did a quick look at the rt2500 driver and did not see any code
> that detects what version chip is being read. If it is possible
> to determine if it is ver 2xxx and not 3xxx, then the probe
> routine should do that and return an error if the wrong driver
> is being loaded. A similar situation arises in the Realtek PCI
> devices. In that case, it is a PCI revision that allows a driver
> to reject the wrong hardware.

This is just a patch to return to the original situation.
(0x050d, 0x7050) was deleted by commit 08b8099c128d601fd675b212ef8b10397706b633
[1], and I was wrong.

[1] <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=08b8099c128d601fd675b212ef8b10397706b633>
