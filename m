Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbJHSr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:47:27 -0400
Date: Thu, 8 Oct 2015 14:47:24 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: staging: wilc1000: WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Message-ID: <20151008184724.GA11027@kroah.com> (sfid-20151008_204743_971409_AF4AFFF4)
References: <5616B60F.7040804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5616B60F.7040804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 08, 2015 at 09:29:35PM +0300, Stanislav Kholmanskikh wrote:
> Hi!
> 
> I noticed that drivers/staging/wilc1000/Kconfic defines:
> 
> config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
>         bool "Dynamically allocate memory in real time"
>         ---help---
>           This choice supports dynamic allocation of the memory
>           for the receive buffer. The driver will allocate the RX buffer
>           when it is required.
> 
> 
> "MEMROY" looks suspicious. Is it a typo (MEMORY?) or by intent?

Probably a typo, but be sure to see if it lines up with what the code
expects before changing anything.

Ideally in the end this option should be removed as the driver should
only do dynamic allocation, no static allocation should be needed.

thanks,

greg k-h
