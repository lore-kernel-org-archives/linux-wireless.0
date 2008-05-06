Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56725 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYEFKiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:38:10 -0400
Message-ID: <482034F1.6080400@trash.net> (sfid-20080506_123722_454902_D7B1B275)
Date: Tue, 06 May 2008 12:37:37 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	Dan Williams <dcbw@redhat.com>,
	Roy Marples <uberlord@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: prism54 regression in current -git
References: <480D6CA4.8040205@trash.net> <1208874998.17364.7.camel@localhost.localdomain> <480DFCB4.3040104@trash.net> <43e72e890804221050i47ba5974i59d89cde55645f4@mail.gmail.com> <20080422180332.GD4810@ruslug.rutgers.edu> <480E4FC2.5080909@trash.net> <480F05B2.9080409@trash.net>
In-Reply-To: <480F05B2.9080409@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> Luis R. Rodriguez wrote:
>>>> Good catch. The carrier is set upon a firmware trigger so it is
>>>> possible that when in AP mode we don't hit the trigger in firmware. I
>>>> left open the possibility for this happening and go figure it happens.
>>>> Even if we had docs this probably wouldn't be documented :) I'll try
>>>> to cook up an exception patch now.
>>>
>>> Let me know if this fixes it.
>>> [...]
>>
>> This will probably fix the error I'm seeing, but if I'm not
>> mistaken the mode can be changed while the device is UP and
>> this case is not handled by your patch.
>
> I've verified that is fixes the bug if the device is already
> configured for AP mode when set UP.
>
> It appears to also be working correctly when configuring
> the device for master mode after bringing it up, but I
> don't understand why. 


Just to make sure this doesn't get lost, this fix hasn't made it to
Linus' tree yet and appears to be still needed.
