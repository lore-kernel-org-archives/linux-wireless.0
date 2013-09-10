Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45275 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3IJPtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 11:49:06 -0400
Message-ID: <522F3F6B.2070203@candelatech.com> (sfid-20130910_174911_172109_678728DF)
Date: Tue, 10 Sep 2013 08:48:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Always send management frames at MCS-0??
References: <522E1D31.2090403@candelatech.com> <21038.54250.912310.332354@gargle.gargle.HOWL>
In-Reply-To: <21038.54250.912310.332354@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2013 01:10 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> I had a user request that we support always sending management frames
>> (such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
>> where as normal-ish supplicant/linux tends to send them at much higher
>> rates.
>>
>> Any suggestions on how to go about doing this properly?
>
> If this is with ath9k_rate_control, then it is a known bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=927191

I'm not using ath9k rate control in this case, and at least most messages
get through fine.  We didn't actually see any obvious improvement when forcing
everything to 6Mbps, but since my user was asking, I wanted to run the
idea past the list.

Rate control is not perfect, and on initial bringup it doesn't have
many packets to work with so I thought it might still be useful to allow
users to specify a particular rate for EAPOL packets.  Maybe using
a socket ioctl so user-space (ie, supplicant/hostapd) can control it,
for example.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

