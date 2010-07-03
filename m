Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54670 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0GCQfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jul 2010 12:35:54 -0400
Received: by pvc7 with SMTP id 7so1660273pvc.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jul 2010 09:35:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100702164759.GE2381@tuxdriver.com>
References: <4C2CFAEB.9070302@candelatech.com> <20100702141216.GB2381@tuxdriver.com>
	<4C2E170E.6040207@candelatech.com> <20100702164759.GE2381@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 3 Jul 2010 09:35:32 -0700
Message-ID: <AANLkTikKkA7u636p6geS8lAoJEXY51QUGb2hQ6RwnLbN@mail.gmail.com>
Subject: Re: Question on 'iw reg get/set'
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 2, 2010 at 9:48 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Jul 02, 2010 at 09:42:54AM -0700, Ben Greear wrote:
>> On 07/02/2010 07:12 AM, John W. Linville wrote:
>
>> >The ath9k driver is setting its own regulatory restrictions based on
>> >its EEPROM.  Setting the domain from userland can only further restrict
>> >the regulatory settings.  The '98' value represents a synthesized
>> >regulatory domain, based on the intersection of the available source
>> >of regulatory information (which can include the EEPROM, the userland
>> >setting, and a country IE from your AP).
>>
>> Is there any way to get/set these raw settings (like, whatever it has in EEPROM)?
>>
>> I expect we may ship some of these systems overseas, and would like the flexibility
>> to set the country-code for testing purposes, if nothing else.
>
> I'll leave it to the Atheros guys to address this.

Your "expectation" of having the freedom to modify the EEPROM is valid
as I agree with it too but current legislation does not allow for it.
So to support upstream drivers we just cannot allow for those type of
changes. You won't get any support if you try to mess with that stuff
unless we get a change in legislation that says otherwise. Please
refer to:

http://wireless.kernel.org/en/vendors/VendorSupport
http://wireless.kernel.org/en/developers/Regulatory/statement
http://wireless.kernel.org/en/developers/Regulatory

  Luis

>> Is there any documentation as to what '98' really means, or do we just ignore that
>> value and look at the info printed out after that?
>
> '98' pretty much means "look at the info" :-)

Maybe userspace should be changed to interpret these. I'm on vacation
right now though, patch welcomed for iw.

  Luis
