Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45631 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab3FEIGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:06:34 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
References: <20130604130955.GA13788@debian>
	<20130604134340.GA3813@shaftnet.org>
Date: Wed, 05 Jun 2013 11:06:33 +0300
In-Reply-To: <20130604134340.GA3813@shaftnet.org> (Solomon Peachy's message of
	"Tue, 4 Jun 2013 09:43:41 -0400")
Message-ID: <87d2s13rsm.fsf@purkki.adurom.net> (sfid-20130605_100642_158695_8E0336FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solomon Peachy <pizza@shaftnet.org> writes:

> On Tue, Jun 04, 2013 at 06:09:55AM -0700, Dan Carpenter wrote:
>> The patch a910e4a94f69: "cw1200: add driver for the ST-E CW1100 &
>> CW1200 WLAN chipsets" from May 24, 2013, has poor input validation
>> so the user could write to arbitrary memory.
>
>> Also I think this API looks like things which should be done with
>> normal ioctls.  This driver only lets you load the firmware using a
>> very ugly custom debugfs interface?
>
> No, this is a debugging interface designed to interact with the 
> vendor-supplied testing tool and the passthrough API it requires.  The 
> vendor tool controls the device init sequence, including special 
> engineering firmware.
>
> Support for the ETF hooks is optional, and even if compiled in has to be 
> explicitly enabled with a module parameter.
>

[...]

>
> I'll try to robustify this rather ugly interface as much as possible.  

We have nl80211 testmode interface for just stuff like this. I recommend
using that instead of debugfs.

-- 
Kalle Valo
