Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:3656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYIGXOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 19:14:09 -0400
Received: by ug-out-1314.google.com with SMTP id s2so103217uge.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2008 16:14:08 -0700 (PDT)
Message-ID: <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com> (sfid-20080908_011417_213526_BE6D478D)
Date: Mon, 8 Sep 2008 02:14:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 5:50 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Sun, Sep 7, 2008 at 5:40 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Sun, 2008-09-07 at 17:24 +0300, Tomas Winkler wrote:
>>> On Sun, Sep 7, 2008 at 4:39 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
>>> >> This series should fix mac problems in disassociation
>>> >> There are two basic problems disassociation in current implementation.
>>> >> The order of steps in the dissociation flow and missing proper
>>> >> disassociation when moving from one AP to another.
>>> >
>>> > Mind if I adopt this patch series? I've done only slight modifications
>>> > so far (the int->bool thing I asked for) and have rebased all the
>>> > patches I had already posted on top of it. The arguments to
>>> > ieee80211_set_disassoc are changing a lot in my patch series anyway so
>>> > I'll just work on top of the bool/bool thing and  then fix it up, ok?
>>>
>>> Don't mind just need to test them properly and update commit messages.
>>> Any suggestion how we do that?
>>
>> I've already changed the commit messages slightly, you can find my
>> versions at http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
>> (disassoc-part-{1,2,3}.patch). If you want to test those by themselves
>> that would probably be useful, and if you want to test my complete mlme
>> rewrite I'd appreciate that too, but I'm not done rebasing yet :)
>
> Okay I'll take first the 3 patches then now and I will check the
> rewrites after that .

In general it works but I didn't test all the corner cases yet. Not
sure this is related but.
why I'm hitting unathorized prot messag for subif_start_xmit.
Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
before.

Thanks
Tomas

> Thanks
> Tomas
>
