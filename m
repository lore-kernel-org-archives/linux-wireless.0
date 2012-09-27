Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54732 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2I0PRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 11:17:03 -0400
Message-ID: <50646DEB.8020400@lwfinger.net> (sfid-20120927_171714_346192_90FC7CAD)
Date: Thu, 27 Sep 2012 10:16:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: use %*ph[C] to dump small buffers
References: <1348667852-5957-1-git-send-email-andriy.shevchenko@linux.intel.com> <1348677946.15175.8.camel@joe-AO722>
In-Reply-To: <1348677946.15175.8.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2012 11:45 AM, Joe Perches wrote:
>
> rate_mask uses:
>
> 	u32 ratr_bitmap = (u32) mac->basic_rates;
> ...
> 	u8 rate_mask[5];
> ...
> 	[sets ratr_bitmap as u32]
> ...
> 	*(u32 *)&rate_mask = ((ratr_bitmap & 0x0fffffff) |
> 				      ratr_index << 28);
> ...
> 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
>
> Looks like a possible endian misuse to me.

Joe,

I had to track the flow through two more routines, but I think your analysis is 
correct. The only BE platform I have does not have any PCIe hardware, thus I can 
only test the USB version. It does not show a major problem, but this one with 
the rate masks would be subtle.

Thanks,

Larry


