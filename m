Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:62605 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936600Ab0B1Tdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 14:33:42 -0500
Message-ID: <4B8AC1BE.6000603@gmail.com>
Date: Sun, 28 Feb 2010 20:19:26 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: prahal@yahoo.com, John Linville <linville@tuxdriver.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] rt2x00: Fix TX status reporting for rt2800pci.
References: <4B8A9670.1080906@yahoo.com>
In-Reply-To: <4B8A9670.1080906@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/10 17:14, Alban Browaeys wrote:
> After testing, we found that TX_STA_FIFO_MCS is the last MCS value
> tried. If the transmission failed, 8 frames have been transmitted. If the
> transmission succeed, we can easily compute the number of retry.  This
> patch fix
> the way status is reported to mac80211 rate control. It has 2 bugs :
> 
> 1. mcs can contain the short preamble flag and it will lead to wrong
> computations.
> 
> 2. minstrel nearly always say that 54 Mbits is the best rate, even if we
> are
> very far from the AP
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

