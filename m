Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:18206 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYFKLzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 07:55:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1418926rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 04:55:38 -0700 (PDT)
Message-ID: <1ba2fa240806110455u7547cde8gff1128b03ce800aa@mail.gmail.com> (sfid-20080611_135544_821006_F9E14F22)
Date: Wed, 11 Jun 2008 14:55:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com>
	 <1213001797.698.57.camel@johannes.berg>
	 <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com>
	 <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
	 <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com>
	 <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com>
	 <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com>
	 <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 2:03 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jun 10, 2008 at 9:36 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Tue, Jun 10, 2008 at 9:32 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Tue, Jun 10, 2008 at 4:57 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>>>> On Mon, Jun 9, 2008 at 1:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>> On Mon, Jun 9, 2008 at 2:01 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>>> On Mon, Jun 9, 2008 at 1:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>>>>>> On Mon, 2008-06-09 at 10:53 +0300, Ron Rindjunsky wrote:
>>>>>>>> >
>>>>>>>> > I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
>>>>>>>> > requirement for 802.11n to older kernels by relying on the old
>>>>>>>> > internal mac80211 hacked up MQ support. I've tested the build on
>>>>>>>> > 2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
>>>>>>>> > particularly iwl4965 using 11n on 2.6.22.
>>>>>>>> >
>>>>>>>>
>>>>>>>> in config.mk you put MAC80211_QOS=m, and i guess that the intention was to put
>>>>>>>> CONFIG_MAC80211_QOS=m
>>>>>>>> if this is the case then the compilation fails
>>>>>>>
>>>>>>> It should be "y"
>>>>>>>
>>>>>>> johannes
>>>>>>>
>>>>>>
>>>>>> Danke
>>>>>
>>>>> OK found some more issues. v4.2 pushed out and new tarball
>>>>> regenerated. This has been tested by Intel on 802.11n on iwl4965.
>>>>
>>>> I couldn't  make wme.c compiled for kernels > 22 unless I've added the
>>>> else statement  bellow into confg.mk
>>>> You've reported that it worked for you so what did I wrong?
>>>>
>>>> ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),)
>>>> $(warning "WARNING: You are running a kernel >= 2.6.23, you should
>>>> enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11n support")
>>>> else
>>>> CONFIG_MAC80211_QOS=y
>>>
>>> Well this is forcing this option on kernels where it probably was
>>> available. I don't recall where we added this but I was relying on
>>> your .config. We forced this for older kernels as we are providing the
>>> infrastructure within the code but for newer kernels you need MQ
>>> support and NET_SCHED. If we force enable it and if those options are
>>> not enabled it'll fail. This is why we have this big fat warning if MQ
>>> is detected as disabled for >= 2.6.23.
>>>
>>> Let me know what you think.
>>
>> OK I guess we should just enable it if MQ is enabled, point taken.
>> Committed and pushed, thanks.
>
> Actually no, take that back. CONFIG_MAC80211_QOS should probably just
> be enabled if NET_SCHED is present.
>
> Johannes -- why do we have the requirement for NETDEVICES_MULTIQUEUE
> on CONFIG_MAC80211_QOS? My current config doesn't have it it and
> CONFIG_MAC80211_QOS still works right now enabled. Of course the
> driver I'm testing doesn't have 11n though.
>
> Shouldn't we just make MAC80211_QOS depend on NET_SCHED and figure out
> we can't support 11n based on NETDEVICES_MULTIQUEUE?
>
>  Luis
>

We need both to be enabled NET_SCHED and MULTIQUEUE for both WME and
HT.  Both features requires multiple queues and scheduling.
Tomas;
