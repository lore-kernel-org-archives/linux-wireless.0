Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:57172 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaENVvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 17:51:51 -0400
Date: Thu, 15 May 2014 07:51:26 +1000
From: James Cameron <quozl@laptop.org>
To: WebAV <webav@free.fr>
Cc: Avinash Patil <avinashapatil@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Mwifiex driver on Globalscale Mirabox
Message-ID: <20140514215126.GA15419@us.netrek.org> (sfid-20140514_235154_308889_90F79DEE)
References: <5346DED8.2030704@free.fr>
 <CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com>
 <53480138.2080805@free.fr>
 <53733AB4.7010500@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53733AB4.7010500@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2014 at 11:43:16AM +0200, WebAV wrote:
> The FW is mwifiex 1.0 (14.66.9.p96) which I think is the last one.
> [...]
> mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1397151023.654452): 0x107,
> [...]
> mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1397151033.670677) = 0x107, act = 0x0

My guess is that the driver has sent an extended scan command to
firmware which does not support it, the result is a timeout.  If I'm
right, what we're missing is a patch that uses the new fw_api_ver
before scan.

The inability to recover afterwards is a different problem.

-- 
James Cameron
http://quozl.linux.org.au/
