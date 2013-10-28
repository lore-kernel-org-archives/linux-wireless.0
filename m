Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27305 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3J1VLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 17:11:52 -0400
Message-ID: <526ED316.7090205@qca.qualcomm.com> (sfid-20131028_221155_409318_F4E04BFD)
Date: Mon, 28 Oct 2013 14:11:50 -0700
From: Jeffrey Johnson <jjohnson@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency
 ranges(s)
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>  <1382020835.14410.16.camel@jlt4.sipsolutions.net>  <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>  <1382035171.22901.13.camel@dcbw.foobar.com>  <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAF6F@nasanexd01a.na.qualcomm.com>  <CAB=NE6UkKuSzH4x2SjkE0pRTVCVa3k7g=_ZeU_JE+t2OovRoEg@mail.gmail.com>  <D19FD2B13A40CD4B8DA64DB9B8F112E9218E461D@nasanexd01a.na.qualcomm.com> <1382986906.7298.10.camel@dcbw.foobar.com>
In-Reply-To: <1382986906.7298.10.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2013 12:01 PM, Dan Williams wrote:
> On Mon, 2013-10-28 at 18:08 +0000, Chauhan, Rajesh wrote:
>> Hi Luis,
>>
>> For "enough information for proper usage" - how about if I add an attribute for the source of interference (say, for example, "cellular") for each of those frequency range?
> When you say "cellular" here, do mean a WWAN card in the same machine,
> sharing the antenna (or using a very very nearby antenna) with the WiFi
> card?  Or do you mean a close-by phone, or a tower itself?  How is this
> different from BT coexistence or WiMAX coexistence?
>
One use case would be a colocated WWAN card sharing an antenna or using 
a very very nearby antenna.  There could be other use cases. I would say 
this is complimentary to coexistence.  The idea is to tell userspace 
which frequencies have know sources of interference so that they can be 
avoided, and hence coexistence would not be required.  If userspace 
chooses to use an "unsafe" frequency, the the driver's coexistence logic 
would then be utilized, but the user experience could suffer compared to 
if a "safe" frequency had been selected.

The issue that has been debated internally is whether or not userspace 
needs to know the source of the interference.  In other words, if we 
have an enumerated set of interference sources, would userspace behave 
differently based upon the source?

This is, after all, just meant to be a hint to userspace to give it more 
information to use when selected a channel to be used in a master mode 
of operation.



