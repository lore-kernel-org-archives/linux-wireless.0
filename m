Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35177 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab1GRQ6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 12:58:25 -0400
Message-ID: <4E24662F.2020705@gnu.org> (sfid-20110718_185829_309821_63CEB737)
Date: Mon, 18 Jul 2011 12:58:23 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] b43: correctly display longer chipsets ids
References: <1310860329-6855-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1310860329-6855-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2011 07:52 PM, Rafał Miłecki wrote:
> Some of the newer Broadcom chipsets have longe names like BCM43224,
> BCM43225, etc. However Broadcom decided to keep using u16 for storing
> them. Use %X or %d depending on chip_id value to avoid BCMA8D8, etc.
> ---
> Is there any nicer way of doing that? Currently I have whole string
> duplicated. Can we define part of the format using condition? Like
> (chip_id>  0x9999) ? "%d" : "%04X"

The standard way is snprintf().  The hacky way would be to convert 
numbers over 0x9999 to the numbers that would display in hex as the 
original numbers would show in decimal.

If we are only going to use those numbers in one place, I'd use 
snprintf().  If there are chances that the number would be used in many 
places, perhaps having the hex id representation would be justified.

-- 
Regards,
Pavel Roskin
