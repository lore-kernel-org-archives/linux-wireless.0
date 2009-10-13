Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36979 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZJMJMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:12:01 -0400
Received: by ewy4 with SMTP id 4so3167103ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 02:11:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255377460.30637.150.camel@rc-desk>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
	 <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
	 <20091012185943.GC2794@tuxdriver.com>
	 <1255377460.30637.150.camel@rc-desk>
Date: Tue, 13 Oct 2009 11:11:24 +0200
Message-ID: <8ccf2e9c0910130211j6f522d1ia4dc3a764896f974@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 02/17 v2.6.32] iwl3945: update
	iwl3945_apm_init()
From: Vedran Rodic <vrodic@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you all very much.

I don't have sophisticated power measurement devices to confirm these
fixes, and I've only tried patch 2/17, reporting back it on bug
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2094 that the
problem is still not fixed with this patch applied only.


I originally tested temperature difference near the WLAN card
location. It's hard to compare overall laptop power usage between
Windows XP and Linux because there are other drivers that can make a
difference too.

Unfortunately, I don't have Windows XP anymore to compare since I've
upgraded my hard drive, but I'll be able to test further fixes by
watching the /sys/class/power_supply/BAT0/power_now on my X60s.

Can you describe your testing methodoloy? Are you testing just the
mini PCI card usage? Are you comparing to Windows XP or Vista drivers?

On Mon, Oct 12, 2009 at 9:57 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi John,
>
> On Mon, 2009-10-12 at 11:59 -0700, John W. Linville wrote:
>> On Fri, Oct 09, 2009 at 01:20:18PM -0700, Reinette Chatre wrote:
>> > From: Ben Cahill <ben.m.cahill@intel.com>
>> >
>> > Update iwl3945_apm_init() to set up device registers in sequence most recently
>> > recommended by factory.
>> >
>> > Add resets for APMG interrupts and radio chip, formerly done only in
>> > iwl3945_apm_reset(); moving them here assures that apm_init() will do
>> > a complete job of preparing hardware not only after platform boot,
>> > but also after apm_stop() has executed (due to rfkill, ifconfig down,
>> > driver unload, etc.).  This is in preparation to completely remove apm_reset().
>> >
>> > Add some comments.
>> >
>> > Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
>> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> Is this actually a regression?  Can you provide a reference to the bug report?
>
> This is something we discovered in the lab when we connected power
> measurement tools to the device when the interface was down. In this
> scenario the device is using a lot of power. This is not a regression
> from the previous kernel version, it is something that was broken for a
> while and only recently discovered.
>
> Patches 2/17 and 3/17 address this issue and the above comment applies
> to both.
>
> We are still looking into issues related to this discovery and you may
> see more fixes for this problem.
>
> Reinette
>
>
>
>
>
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry(R) Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay
> ahead of the curve. Join us from November 9 - 12, 2009. Register now!
> http://p.sf.net/sfu/devconference
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
