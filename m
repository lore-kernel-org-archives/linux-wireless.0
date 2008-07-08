Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from THAUM.MIT.EDU ([18.95.3.27]:47024 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbYGHFMd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 01:12:33 -0400
Message-ID: <4872F740.50608@myrealbox.com> (sfid-20080708_071247_522131_B33CE808)
Date: Tue, 08 Jul 2008 01:12:32 -0400
From: Andy Lutomirski <luto@myrealbox.com>
MIME-Version: 1.0
To: hmh@hmh.eng.br
CC: dcbw@redhat.com, zhu.yi@intel.com, linux-wireless@vger.kernel.org
Subject: Re: Question on rfkill double block
References: <1214982208.14590.473.camel@debian.sh.intel.com> <1215018189.29117.32.camel@localhost.localdomain> <20080704195543.GB27898@khazad-dum.debian.net> <1215450664.17128.64.camel@localhost.localdomain> <20080707204708.GA3166@khazad-dum.debian.net>
In-Reply-To: <20080707204708.GA3166@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Mon, 07 Jul 2008, Dan Williams wrote:
>> On Fri, 2008-07-04 at 16:55 -0300, Henrique de Moraes Holschuh wrote:
>>> On Wed, 02 Jul 2008, Dan Williams wrote:
>>>> That would be more useful than the current enum, yes.
>>> Dan, you do have a strong user case for "just software rfkilled", "just
>>> hardware rfkilled" and "soft+hard rfkilled" as opposed to simply "software
>>> rfkilled" and "hardware rfkilled, maybe software rfkilled as well" ?
>> No, I don't have a _NetworkManager_ usecase for being able to
>> distinguish between HW and HW+SW.  Just an observation that stuff other
>> than NM might want to figure that out for UI or something.
> 
> Ok.  I will still *try* to implement the fourth state, but I will post the
> patch as a RFC.  If it is too messy or complex, I will recommend that we
> drop it.

I'm still a bit confused.

Suppose I have a laptop with a physical switch marked "radio" which 
tells the OS which position it's in *and does nothing else* (via ACPI or 
whatever) and a radio which has a (pure) software rfkill controller. 
Suppose further that this laptop has a radio button as well.

This would look exactly like my Thinkpad X61s, except that the rfkill 
switch would be connected to the rfkill controller in software, not 
hardware.

I think it would have the exact same problem and the fourth state 
wouldn't help because it would never be any variety of HARD_BLOCKED.

--Andy
