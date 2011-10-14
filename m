Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2705 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab1JNOnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 10:43:45 -0400
Message-ID: <4E984A96.9080804@broadcom.com> (sfid-20111014_164349_384241_79D922D3)
Date: Fri, 14 Oct 2011 16:43:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: How to create library module with callbacks?
References: <CACna6ryphLSrh5vtOEDXek7s9DGxWKSSgQB-KJVLyzfmBCP3KA@mail.gmail.com>
In-Reply-To: <CACna6ryphLSrh5vtOEDXek7s9DGxWKSSgQB-KJVLyzfmBCP3KA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2011 03:21 PM, Rafał Miłecki wrote:
> I want to create module library, which will handle PHY operations on
> Broadcom card. For most of the time, I'm going to call library
> functions from b43.
> 
> However, there are places where I need to call some (b43) driver
> function from library module.
> 
> How can I handle that? Should I pass some functions pointers to the
> library? Is that going to work? Or is there a better approach?
> 
> P.S.
> I'm asking at linux-wireless, it's not wireless related however. I
> think question is quite simple for C hackers and there is no need to
> hit LKML.
> 

Hi Rafał,

It should be no different as normal drivers do. In your case I would say
b43 registers itself with phylib module and provides phylib_ops. It
could also provide the bcma_device for the 80211 core so the phylib can
use bcma directly. Whether or not phylib is still a library module when
doing so can be argued. As it does not provide a system function by
itself I tend to say it is.

I would suggest to look into mac80211 to see how it deals with the
callbacks it does into the device drivers.

Gr. AvS

