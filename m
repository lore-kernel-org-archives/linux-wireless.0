Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49608 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbZLDWED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 17:04:03 -0500
Received: by iwn1 with SMTP id 1so1911743iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 14:04:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091204214904.GB3595@tuxdriver.com>
References: <b0c954732ea30effda967bd97ef30597@127.0.0.1> <b6c5339f0911171411r53104fcqadb2a6f5a1240308@mail.gmail.com>
	<2059abb0cf19e10a615a9db89742acb7@127.0.0.1> <20091118194251.GA29670@hash.localnet>
	<43e72e890911181201g571f51a4h7f5bed55e835ca3b@mail.gmail.com>
	<c03c5be87fe5e51ff5f1442a3d84e27a@127.0.0.1> <43e72e890912041316r3954fd27vcab8a4c425562615@mail.gmail.com>
	<20091204214904.GB3595@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Dec 2009 14:03:48 -0800
Message-ID: <43e72e890912041403r70aee61bgbae5d045ba8fcad5@mail.gmail.com>
Subject: Re: [ath5k-devel] "iwlist scan" shows same ap twice
To: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>
Cc: Florian Engelhardt <flo@dotbox.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 4, 2009 at 1:49 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Fri, Dec 04, 2009 at 01:16:54PM -0800, Luis R. Rodriguez wrote:
>> On Fri, Dec 4, 2009 at 1:02 PM, Florian Engelhardt <flo@dotbox.org> wrote:
>> > On Wed, 18 Nov 2009 12:01:08 -0800, "Luis R. Rodriguez" <mcgrof@gmail.com>
>> > wrote:
>> >> On Wed, Nov 18, 2009 at 11:42 AM, Bob Copeland <me@bobcopeland.com>
>> > wrote:
>> >>>
>> >>> Ok, fair enough.  We should try to figure out where the 0x5d and 0x43
>> >>> come from.  It could be memory corruption, for example, but 0x5d and
>> >>> 0x43 aren't poison values.  You may try turning on slub/slab debugging
>> >>> just to be sure.
>> >>
>> >> He noted he sees this with iwl drivers though., Florian, please
>> >> correct me if I'm wrong.
>> >
>> > You are right. Any news on this?
>> >
>> > i attached a new scan from the Laptop with intel chipset (iwlagn module).
>> > The first Cell ist the correct access point the second cell with the same
>> > ESSID doesn't exist. I don't know why iwlist scan finds this AP.
>>
>> Please consider burrying iwlist and iwconfig under some ditch and use iw.
>
> Someone suggested reimplementing iwlist, iwconfig, etc as scripts
> around iw -- any takers? :-)

This may help:

http://wireless.kernel.org/en/users/Documentation/iw/replace-iwconfig

I think the *only* command missing is 'iwconfig wlan0 power off'. And
maybe a generic 'iw link' which lists all link information for all
wiphy interfaces, but that should be easy to implement, just have to
get around to it.

  Luis
