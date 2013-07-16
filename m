Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36626 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3GPU5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 16:57:55 -0400
Received: by mail-wi0-f172.google.com with SMTP id c10so4637367wiw.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 13:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DFC5@HASMSX106.ger.corp.intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com> <CAB=NE6VQXQPRK9_Q-Nh+ripRa+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A01AD2DFC5@HASMSX106.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Jul 2013 13:57:34 -0700
Message-ID: <CAB=NE6WY43BYDehH5-MyF0GQORC1dTrNToUsRVC-Q5bDwcna3A@mail.gmail.com> (sfid-20130716_225800_756661_F79D8252)
Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional channels
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "Spinadel, David" <david.spinadel@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>, Jouni Malinen <j@w1.fi>,
	"Ginsburg, Noam" <noam.ginsburg@intel.com>,
	"Perelmooter, Liraz" <liraz.perelmooter@intel.com>,
	"Shalev, Oz" <oz.shalev@intel.com>,
	Michael Green <green@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 10, 2013 at 3:47 AM, Peer, Ilan <ilan.peer@intel.com> wrote:
>> Are you aware of UNII-1, UNII-2, UNII-2E, UNII-3 are specific world regulatory
>> language bands? When I last tried to look for a clear definition I could not find
>> a clear definition of them and its why on the ath module on for QCA modules I
>> state "we call these" in reference to the UNII nomenclature. If we can get a
>> clear resource for its definition that would help here.
>>
>
> Maybe these link will help.
> http://www.gpo.gov/fdsys/pkg/CFR-2010-title47-vol1/xml/CFR-2010-title47-vol1-part15.xml#seqnum15.403
> http://hraunfoss.fcc.gov/edocs_public/attachmatch/FCC-13-22A1.pdf
>
> Anyway, I will use your ''we call these" notation as well :)

No no, this is good, its just United States / FCC biased and I hadn't
seen the documentation you provided before. This confirms these are
official terms but still just US / FCC biased. My point was that we
should be careful to not make global statements on regulatory code
about things that are not global. If we know only the FCC calls this
UNII well lets document that and provide the reference you supplied. I
anticipated having to deal with special case regulatory code outside
of of what CRDA / wireless-regdb provides -- given that CRDA /
wireless-regdb were meant to be more RF agnostic anyway.

Given that other vendors may also want to get the UNII band can you
stuff instead cfg80211_get_unii_band() into reg.c and do the #ifdef
properly with the Kconfig, and export it as well, as well as document
it properly providing the reference you mentioned.

>> > + * 1. Indoor only: a GO can be operational on such a channel, iff there is
>> > + *    clear assessment that the platform device is indoor.
>> > + * 2. Concurrent GO: a GO can be operational on such a channel, iff there is
>> an
>> > + *    additional station interface connected to an AP on this channel.
>> > + *
>> > + * TODO: The function is too permissive, as it does not verify the
>> > + platform
>> > + * device type is indeed indoor, or that the AP is indoor/AC powered.
>>
>> So to do this properly we need an eventual userspace API to throw to
>> kernelspace if we are AC powered? We'll need this to enhance this routine
>> here?
>>
>
> Not sure about this point. I prefer leaving the exact knowledge of the device type, being AC Powered or not (and which type of AC power) etc. out side of the kernel. The approach I chose with this patch was to only allow to start a GO on such a channel, making the basic verification done above, assuming that the user space component guarantees that all the full restrictions are satisfied.

Fair enough. Seems we just need to zero in now on the requirement or
not on the extra flag you suggested.

>> In the meantime, while you get all your patch sets properly developed I'd
>> recommend to define the code returning false there strictly or perhaps for any
>> flag on the channel requiring DFS / no-ibss, or passive scan. The stricter case,
>> defining false always, seems to be what you are suggesting here.
>
> I do not think that this is needed here. Returning false, means that the code should test if the PASSIVE_SCAN and NO_IBSS are not set on the channel we want to start beaconing on.
>
>> Do you have a white list that can exclude some channels for now globally or
>> somehow as all this lines up?
>>
>
> Note sure I understood what you are looking for. Can you please clarify this point?

It was unclear for what exact channels you needed to deal with here.
Given review so far wouldn't it just be DFS flagged channels on some
UNII bands ? Then again if the indoor flag needs to be pegged to to a
specific UNII band and we can do that on wireless-regdb do we even
need the UNII band check routine helper?

  Luis
