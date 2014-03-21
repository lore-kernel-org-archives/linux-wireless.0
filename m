Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53596 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaCUQaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 12:30:55 -0400
Message-ID: <532C6921.5080803@candelatech.com> (sfid-20140321_173059_464133_DA3485B1)
Date: Fri, 21 Mar 2014 09:30:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: add the Rx rate in FW stats
References: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com> <CA+BoTQ=X=UxikrVrmr3hyQgjN2Tg5aeW5Ok7b+23n9X6bxRshA@mail.gmail.com> <87a9cja596.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a9cja596.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2014 09:25 AM, Kalle Valo wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
> 
>> The main problem here is there are subtle yet crazy binary
>> incompatibilities between these firmwares.
>>
>> The best way would probably be to implement wmi as an abstraction
>> layer with completely different backends for different firmware
>> branches/revisions. Otherwise you sign up for some pain..
> 
> Yeah, I'm starting to believe that we will need something like that.
> Other option is just to duplicate wmi.c and wmi.h for each interface
> version. More code, but we get to keep more hair ;)
> 
> But we need to talk a lot more about this. For this patch in question we
> should be able to manage with the current method of handling
> differences.

Lets not duplicate any more code than we have to.  Hopefully we can
get a solid firmware built that everyone can use and let the old firmware
support eventually go away.  In the meantime, we can add hacks as needed
to deal with firmware differences.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

