Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33685 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaFHQB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 12:01:58 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so110430wiw.10
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2014 09:01:57 -0700 (PDT)
Message-ID: <539488F1.2040900@gmail.com> (sfid-20140608_180202_265919_6A63758C)
Date: Sun, 08 Jun 2014 19:01:53 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: Ben Greear <greearb@candelatech.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>	 <87wqczz3h9.fsf@kamboji.qca.qualcomm.com>	 <538CA904.4000508@candelatech.com>	 <87ioojz1b1.fsf@kamboji.qca.qualcomm.com>	 <538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>	 <538CC949.5020901@candelatech.com>	 <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>	 <538CD507.1050803@candelatech.com>	 <87bnu7pqe2.fsf@kamboji.qca.qualcomm.com>	 <53909372.1040707@candelatech.com>	 <87fvjimsxj.fsf@kamboji.qca.qualcomm.com>	 <5391E620.4090706@candelatech.com>	 <87vbscj2ho.fsf@kamboji.qca.qualcomm.com>	 <53932F52.2030203@candelatech.com>	 <8738ffiysv.fsf@kamboji.qca.qualcomm.com>	 (sfid-20140608_103606_337478_803FD86E) <1402218792.4406.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1402218792.4406.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/08/2014 12:13 PM, Johannes Berg wrote:
> On Sun, 2014-06-08 at 11:35 +0300, Kalle Valo wrote:
> 
>>> I was thinking we should not add a MAC to the dump, for privacy concerns,
>>> but whatever user-space tools gather the dump could add MAC if user perfers.
>>
>> The MAC addresses can be extracted from the target memory anyway so I
>> don't see harm from including that in the dump. Is it even possible to
>> address all privacy issues when dealing with firmware dumps?
> 
> We had something of a discussion about this - it's usually not just
> BSSIDs/MAC addresses, but also encryption keys (say WEP keys, or at
> least temporal keys, sometimes more), SSIDs, etc. In short, there's a
> whole bunch of private data that can be included in such dumps.
> 
> However, we haven't really found a good solution. Popping up big scary
> warnings to the user is unlikely to be productive, trying to keep the
> data private and only accessible to (the right) developers is not going
> to work ... encryption might work, but who manages that?
> 

I disagree here. We found something that met the requirements of the organization we work for.
Note that each company has its requirements when it comes to this kind of things.
If we wanted to come up with a community statement of user privacy, the first step would be to stop printing the BSSID of the AP we associate to the kernel which is typically captured automatically by bug trackers...
So we need to separate between different things: we have the kernel / driver on one side, and we have the distribution on the other. We don't ship kernels to user. The distribution does.
The way I see it, we need to keep the distribution informed on what information this dump might include and how easy it is parse / hack. If the distribution wants to enable it or not is another problem.
Loading iwlwifi with debug=0xffffffff or even tracing can record pretty much everything. Should we stop allowing usage of these?
This doesn't make sense to me.

> Certainly the data shouldn't be attached to a public bug tracker
> automatically...
> 

Sure - but again, I don't think that "good" or "bad" will help here. We need to come up with a real statement of what we information might be enclosed and guarantee that nothing else is included in the data. Then we can make a declaration somewhere.
Note that the distribution is shipping the whole package and that the distribution typically have a "legal department" that handles this kind of things - including a privacy statement that is agreed by the user when he installs the distribution.
