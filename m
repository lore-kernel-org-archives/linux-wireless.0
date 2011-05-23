Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40471 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1EWUvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 16:51:44 -0400
Message-ID: <4DDAC8DC.5060803@candelatech.com> (sfid-20110523_225146_844564_15DA934D)
Date: Mon, 23 May 2011 13:51:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com> <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com> <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
In-Reply-To: <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 01:25 PM, Luis R. Rodriguez wrote:
> On Mon, May 23, 2011 at 1:09 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> Makes it basically useless as a 5Ghz AP though, eh?
>
> Um yup. The card is a world roaming card... not an AP card. For AP
> mode of functionality vendors have to go through a regulatory test
> specific to 3 regions, and depending on which region they get
> certification for they will have then programmed in the values
> required for regulatory on the CTLs. The EEPROM would be configured
> for the region the card was being tested for.

Well, if you have an AP on a 5Ghz channel, and associate a station
interface, that one channel becomes
usable, and then you can start hostapd, as far as I can tell.
You just can't use an un-used channel, which is of course
a pain if you want to do some 5Ghz AP testing on a clean
channel!

>> Guess it's time to go find a hack to over-ride eeprom
>> settings :(
>
> Good luck with support from anyone for any further questions ;) [1].

I can certainly disable the module parameter and have it bug for bug
compatible with upstream code.  I'm not going to
write to the eeprom or anything funny like that.

> The real solution to these issues is for regulatory agencies to start
> warming up to the idea about dynamic regulatory selection but for this
> you will also then need to ensure each card gets properly tested for
> each regulatory region -- or we'd have to restrict the card to work in

What kinds of things could fail in one region and not
another?  Are there any known regions of the world where
the AR9380 actually fails to function in any mode?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

