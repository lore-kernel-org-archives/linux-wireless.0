Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50521 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaKJWxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 17:53:25 -0500
Message-ID: <546141E2.2080309@candelatech.com> (sfid-20141110_235328_487435_AC63DEF8)
Date: Mon, 10 Nov 2014 14:53:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: New ath10k CT firmware released.
References: <545BD297.5040806@candelatech.com> <545C16A5.9030106@candelatech.com>
In-Reply-To: <545C16A5.9030106@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2014 04:47 PM, Ben Greear wrote:
> On 11/06/2014 11:57 AM, Ben Greear wrote:
>> I have uploaded the latest CT version of the ath10k firmware.
>>
>> http://www.candelatech.com/ath10k.php
>>
>> This firmware fixes bugs in raw-tx mode, though probably only
>> non-encrypted frames can be sent in this manner, and it requires
>> an out-of-tree patch from Michal Kazior to make it work:
>>
>> http://comments.gmane.org/gmane.linux.drivers.ath10k.devel/246
>>
>> This firmware also significantly improves association times when using
>> more than one vdev.  This, requires an additional kernel patch:
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.17.dev.y/.git;a=commitdiff;h=a9756b6e2efffbec4101dbe81e9d6a2c503239ff;hp=5bfa637376c352fc17c56afc7b1d2e752750162c
> 
> I was a bit too clever it seems....  I have to be more careful about disabling
> the ch reservation when there are no vdevs active, I think.
> 
> Hope to have it fixed shortly.

Looks like firmware was fine, so it remains unchanged.  But, the driver patch has to
be more careful and only disable ch reservation if we currently have an active channel.

This patch (on top of the one linked above) seems to work well:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.17.dev.y/.git;a=commitdiff;h=5ed93f05d72769b06246280d514b72d617bb9fde

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

