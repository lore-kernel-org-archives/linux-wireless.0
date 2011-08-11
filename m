Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1HKSGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 14:06:48 -0400
Subject: Re: [RFC] NFC: NCI protocol proposal
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 20:08:16 +0200
Message-ID: <1313086096.8413.11.camel@sortiz-mobl> (sfid-20110811_200651_687750_C64CAFA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2011-08-09 at 17:04 +0200, Elias, Ilan wrote:
> Hi Lauro, Aloisio, Samuel, all,
> 
> We would like to implement the NFC Controller Interface (NCI) protocol for the NFC subsystem.
> The NCI is a standard communication protocol between an NFC Controller (NFCC) and a Device Host (DH), defined by the NFC Forum.
Just as a side note to our previous thread: As far as I know, NCI is still a draft
(very close to the final version though) and as a consequence only available to
NFC Forum members.


> The NCI protocol implementation will be chip independent and responsible for:
> 	- Reset, initialization and configuration of the NFC controller
> 	- Sending commands/data to the NFC controller
> 	- Receiving responses/notifications/data from the NFC controller
> 	- Flow control for Control and Data Messages
> 	- Segmentation and reassembly for Control and Data Messages
> 	- An addressing scheme for NFC Execution Environments (NFCEE), e.g. 	secure element
> 	- An addressing scheme for Remote NFC Endpoints (NFCEE or RF targets) 	(via logical connections)
Could you give us some more details about those last 2 points ?


> 
> The NCI protocol will be added to the NFC subsystem below the NFC core:
>  
> +--------------------------------------+
> |              USER SPACE              |
> +--------------------------------------+
>      ^                        ^
>      | low-level              | control
>      | data exchange          | operations
>      |                        |
>      |                        v
>      |                  +-----------+
>      | AF_NFC           |  netlink  |
>      | socket           +-----------+
>      | raw                    ^
>      |                        |
>      v                        v
> +---------+             +-----------+
> | rawsock | <---------> | NFC core  |
> +---------+             +-----------+
>                 	            ^
>                               |
>                               v
>               	      +-----------+
>                         | NCI core  |
>                         +-----------+
> 				      ^
> 				      |
> 				      V
> 			      +-----------+
> 			      |  driver   |
> 			      +-----------+
> 
> The driver will register itself to the NCI core, and in turn the NCI core will register itself to the NFC core.
It really looks like the HCI layer I'm currently (slowly) working on. So it does look good to me.
 


> We need to add the following 2 control operations (via generic netlink):
> 	- Dev_up, which turn on the NFC controller (this operation may take a 	few seconds, as it can download new FW to the NFC controller)
> 	- Dev_down, which turn off the NFC controller
> The dev_up/down approach was also used with HCI protocol in the BlueZ project.
So after talking with Lauro and Aloisio about it, and listening to
Johannes argument, I think it does make sense to add those 2 hooks.


> 
> We suggest placing the NCI code in the net\nfc folder (beside the NFC code), as it's a generic and chip independent protocol, and not a driver.
Yep, you probably want to have an nci directory there.

Out of curiosity, is this NCI HW of yours based on the TRF7970A
chipset ?

Cheers,
Samuel.


