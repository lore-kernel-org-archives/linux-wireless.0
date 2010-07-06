Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:17545 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0GFIzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 04:55:39 -0400
Message-ID: <4C32EF19.1000604@nokia.com>
Date: Tue, 06 Jul 2010 11:53:45 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Ohad Ben-Cohen <ohadb@ti.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> <1278376666-3509-12-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-12-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 07/06/2010 03:37 AM, ext Ohad Ben-Cohen wrote:
> From: Ohad Ben-Cohen<ohadb@ti.com>
>
> Introduce a platform device support which is decoupled
> from the life cycle of the sdio function.
>
> The platform device objective is to deliver board-specific
> values (like irq, ref_clock, and software card-detect
> emulation control).
>
> The driver can then dynamically create (or destroy)
> the sdio function whenever the wlan interface is
> brought up (or down), as part of the power() operation.

Is this the right approach? Why should you emulate a card disconnect event when 
the wlan interface is brought down?

Physically the card is never disconnected. So I don't see why we should fake it.
Could you please explain why you need to do this?

br,
-roger
