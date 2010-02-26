Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:20565 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964881Ab0BZOic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 09:38:32 -0500
Message-ID: <4B87DCE4.3090708@yahoo.com>
Date: Fri, 26 Feb 2010 15:38:28 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: prahal@yahoo.com
CC: John Linville <linville@tuxdriver.com>,
	Josef Bacik <josef@redhat.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: Fix TX status reporting for rt2800pci.
References: <4B87D9FF.5080105@yahoo.com>
In-Reply-To: <4B87D9FF.5080105@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/02/2010 15:26, Alban Browaeys wrote:
> After testing, we found that TX_STA_FIFO_MCS is the last MCS value
> tried. If the transmission failed, 8 frames have been transmitted. If the
> transmission succeed, we can easily compute the number of retry.  This 
> patch fix
> the way status is reported to mac80211 rate control. It has 2 bugs :
>
> 1. mcs can contain the short preamble flag and it will lead to wrong
> computations.
>
> 2. minstrel nearly always say that 54 Mbits is the best rate, even if 
> we are
> very far from the AP
>
> TX_DONE_FALLBACK flag meaning has been changed : it means that a
> fallback rate table is used by the hardware.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

This patch fixes the probe timeout after less than 2 minutes.
I probably should have resend the two patches (tx done hw implementation 
and this one). Just thought about it.
As it applies above the tx done implementation. I did not make one that 
applies above the software only implementation as it is broken since 
entry index was replaced by key index in rt2800pci write tx desc (as 
Wireless Cli Id).


