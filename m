Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1351 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3CRTik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:38:40 -0400
Message-ID: <51476D25.6030609@broadcom.com> (sfid-20130318_203844_173141_B60FF69B)
Date: Mon, 18 Mar 2013 20:38:13 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	664767@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
References: <20130317144603.GA4850@stt008.linux.site>
 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
 <20130317152428.GA4940@stt008.linux.site>
 <20130317175658.GA8181@elie.Belkin>
 <20130317182725.GA5811@stt008.linux.site>
 <20130317183344.GA8786@elie.Belkin>
 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
 <20130318083752.GA6570@elie.Belkin>
In-Reply-To: <20130318083752.GA6570@elie.Belkin>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2013 09:37 AM, Jonathan Nieder wrote:
> Camaleón wrote[1]:
>
>> vermagic:       3.9.0-rc2 SMP mod_unload modversions 686
>>
>> As soon as I load the brcmsmac module, N-M pop-ups and asks for the
>> secrets... constantly until it quits, that is, I cannot even connect
>> to the wifi AP with the Broadcom card, it's a bit frustrating :-(

Sorry to hear. Reading back the bug report I noticed you are having a 
bcm4313 and we recently had a regression on it. Could you provide 
debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware

The regression was caused by following commit:

"brcmsmac: support 4313iPA" b6fc28a158076ca2764edc9a6d1e1402f56e1c0c

If possible you can revert that and see how that goes.

Regards,
Arend

>
> Thanks.
>
>> I also downloaded Debian experimental kernel sources (3.8.2), do you
>> want me to compile and test this?
>
> I see no reason to do that.
>
> Hm.
> Jonathan
>
> [1] http://bugs.debian.org/664767
>


