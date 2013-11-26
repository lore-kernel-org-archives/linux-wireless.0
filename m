Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:43924 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932582Ab3KZVwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 16:52:05 -0500
Message-ID: <1385502722.18487.9.camel@joe-AO722> (sfid-20131126_225210_583294_56C3EC7B)
Subject: Re: [PATCH v3] staging: vt6656: mac.c MACvWriteMultiAddr: Remove
 secondary variables
From: Joe Perches <joe@perches.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 13:52:02 -0800
In-Reply-To: <1385498747.10545.7.camel@canaries32-MCP7A>
References: <1385498747.10545.7.camel@canaries32-MCP7A>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-26 at 20:45 +0000, Malcolm Priestley wrote:
> Covert to pointer, point to callers buffer and remove casting in callers.
[]
> diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
[]
> @@ -1394,8 +1394,8 @@ static void device_set_multi(struct net_device *dev)
>              mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));

A possible thing to fix for another day:

mc_filter is u32 but should probably be __le32 instead.
ORing a u32 and a cpu_to_le32 isn't ideal.


