Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42031 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1AKRhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 12:37:36 -0500
Subject: Re: [PATCH] wl12xx: reset 5ghz num channels on hw init
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294693444-30807-1-git-send-email-arik@wizery.com>
References: <1294693444-30807-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 19:37:46 +0200
Message-ID: <1294767466.1981.6.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-10 at 22:04 +0100, Arik Nemtsov wrote:
> The number of 5ghz channels is set to 0 when 11a is not supported in the
> NVS file. When a single rmmod/insmod of wl12xx_sdio this leads to a
> supported band (5ghz) with 0 supported channels, which mac80211
> considers illegal.
> 
> Fix this by always resetting the number of supported 5ghz channels
> before the HW is registered.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Just for the record, this patch is not necessary anymore, once my new
patch that avoids changing the global structs (as suggested by Johannes)
gets in.


-- 
Cheers,
Luca.

