Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25380 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbFHVth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 17:49:37 -0400
Date: Mon, 8 Jun 2015 23:49:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFC: nci: hci: Fix releasing uninitialized skbs
Message-ID: <20150608214923.GH5089@ribalta.mp.intel.com> (sfid-20150608_235006_866505_B4A50EC7)
References: <1433119485.2984.36.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433119485.2984.36.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Sun, May 31, 2015 at 05:44:45PM -0700, Joe Perches wrote:
> Several of these goto exit; uses should be direct returns
> as skb is not yet initialized by nci_hci_get_param().
> 
> Miscellanea:
> 
> o Use !memcmp instead of memcmp() == 0
> o Remove unnecessary goto from if () {... goto exit;} else {...} exit:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/nfc/nci/hci.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
