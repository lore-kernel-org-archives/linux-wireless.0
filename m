Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:13009 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbZG2WEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 18:04:37 -0400
Received: by an-out-0708.google.com with SMTP id d40so1278925and.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 15:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248904631.1216.1027.camel@rc-desk>
References: <20090729214510.31738.90990@cl-1649.ham-01.de.sixxs.net>
	<43e72e890907291453k444e2d06k864149ddcda8f351@mail.gmail.com>
	<1248904631.1216.1027.camel@rc-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 29 Jul 2009 15:04:17 -0700
Message-ID: <43e72e890907291504o1de0fb31hde287f2af42dcc8@mail.gmail.com>
Subject: Re: [Linux Wireless] Update of "en/users/Download" by ReinetteChatre
To: reinette chatre <reinette.chatre@intel.com>, rmacko72@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 2:57 PM, reinette
chatre<reinette.chatre@intel.com> wrote:
> On Wed, 2009-07-29 at 14:53 -0700, Luis R. Rodriguez wrote:
>> On Wed, Jul 29, 2009 at 2:45 PM, Linux
>> Wireless<johannes@sipsolutions.net> wrote:
>> > Dear Wiki user,
>> >
>> > You have subscribed to a wiki page or wiki category on "Linux Wireless" for change notification.
>> >
>> > The "en/users/Download" page has been changed by ReinetteChatre:
>> > http://wireless.kernel.org/en/users/Download?action=diff&rev1=93&rev2=94
>> >
>> >  }}}
>> >  '''Install''':
>> >
>> > - We use the updates/ directory so your distribution's drivers are left intact.
>> > + We use the updates/ directory so your distribution's drivers are left intact. By default depmod will search this directory first, but if you find that it does not then check that your depmod.conf file lists the search order correctly with ''updates'' appearing first (before ''built-in'').
>>
>> Hm, so compat-wireless now actually checks this for you and if its not
>> there it adds it for you. Was there an issue with a particular user on
>> this?
>
> Yes, a madriva user ran into this problem. See
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2061#c6

Roman, I added a little check for this, specifically since another
user reported the same issue. Did you use bleeding edge
compat-wireless?

The script is in:

scripts/check_depmod

We run this at make install time.

Can you run that manually?

  Luis
