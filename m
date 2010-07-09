Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:35652 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0GIINJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 04:13:09 -0400
Message-ID: <4C36DA04.3090209@nokia.com>
Date: Fri, 09 Jul 2010 11:12:52 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: Nicolas Pitre <nico@fluxnic.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> 	<1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com> 	<AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com> 	<4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com> 	<4C333E0D.2070601@nokia.com> <alpine.LFD.2.00.1007061316010.6020@xanadu.home> <AANLkTin7jIAIiN_JHMxX74K-EBDtDNwUQMlIf4C6RCHD@mail.gmail.com>
In-Reply-To: <AANLkTin7jIAIiN_JHMxX74K-EBDtDNwUQMlIf4C6RCHD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On 07/08/2010 11:10 PM, ext Ohad Ben-Cohen wrote:
> Hi Nicolas and Roger,
>
> On Tue, Jul 6, 2010 at 8:42 PM, Nicolas Pitre<nico@fluxnic.net>  wrote:
>> On Tue, 6 Jul 2010, Roger Quadros wrote:
>>> If the Power enable GPIO can be treated as SDIO slot supply (i.e. vmmc), then
>>> the SDIO/MMC core should tackle it, just like it deals with supply for slots
>>> with removable cards.
>>
> ...
>> Another function pair would be needed instead, which would do almost
>> like the suspend/resume code is already doing.  Something like:
>
> Thanks a lot for your review and comments, and for taking the time to
> present your approach.

you're welcome :)
>
> I like it !
>
> It'd allow us to lose the software (or fake if you want ;) card detect
> mechanism, which is something that should have been added to each
> platform we wanted to support.
>
> We would only need to make it possible to deliver board-specific data
> to the function driver (e.g., in the case of the wl1271, we need irq
> and board_ref_clock data).  That would require some board-level
> platform-data configuration, which will be specific to the controller
> to which the device is hardwired to. This data should propagate
> through the host controller to the SDIO core so it would eventually be

why should platform data go through the host controller? You are already 
creating a new platform device for wl1271_sdio just to pass platform_data so the 
platform data for that can be passed directly from board files to this platform 
device. It doesn't need to go via host controller.

I think this case is specific to wl1271. Ideally wl1271 should have used the 
SDIO's in-band interrupt delivery mechanism and SDIO Configuration space to 
provide this information to make it truly plug n play.

br,
-roger
