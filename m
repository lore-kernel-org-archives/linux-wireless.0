Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46812 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0AOBIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 20:08:19 -0500
Message-ID: <4B4FBFFA.3020909@free.fr>
Date: Fri, 15 Jan 2010 02:08:10 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: check that ieee80211_set_power_mgmt only 	handles
 STA interfaces.
References: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr> <43e72e891001141652h6830c395ufea7602c009292f2@mail.gmail.com>
In-Reply-To: <43e72e891001141652h6830c395ufea7602c009292f2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Thu, Jan 14, 2010 at 4:48 PM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>> ieee80211_set_power_mgmt is meant for STA interfaces only. Moreover,
>> since sdata->u.mgd.mtx is only initialized for STA interfaces, using
>> this code for any other type of interface (like IBSS) will result in a
>> oops.
> 
> Is this path even possible at this point? Is this a stable fix?
> 
>   Luis
> 

This is the case if you create a monitor interface (I wonder why it did
not notice before however). I think we should return -EOPNOTSUPP instead
of 0 (otherwise iwconfig shows "Power management:on" on monitor
interface). As such, this is a stable fix.

Do i need to send an updated patch?

Regards,
Benoit

