Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:14975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZBWVg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 16:36:29 -0500
Received: by fg-out-1718.google.com with SMTP id 16so14409fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 13:36:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890902231318u6e6a01b9jffcf3846de1e5881@mail.gmail.com>
References: <499C7DC0.4040608@lwfinger.net>
	 <20090218224833.GB28733@bombadil.infradead.org>
	 <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com>
	 <43e72e890902201233w95b4aaew1fa0bbf06196d74f@mail.gmail.com>
	 <69e28c910902201307i398b4a89na4ce0205d66ee921@mail.gmail.com>
	 <20090220234032.GB23428@bombadil.infradead.org>
	 <69e28c910902210731x46fab8a7qfecb276a66f7a890@mail.gmail.com>
	 <43e72e890902230951x71e7d53fwcbcb6e89143b71d9@mail.gmail.com>
	 <69e28c910902231233p57923881r75624e752ba59b92@mail.gmail.com>
	 <43e72e890902231318u6e6a01b9jffcf3846de1e5881@mail.gmail.com>
Date: Mon, 23 Feb 2009 22:36:26 +0100
Message-ID: <69e28c910902231336g77a55306w6a592f5b4d8f02b@mail.gmail.com> (sfid-20090223_223632_409694_C5CF0A82)
Subject: Re: ieee80211_regdom module parameter for cfg80211
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 10:18 PM, Luis R. Rodriguez <mcgrof@gmail.com> =
wrote:
> On Mon, Feb 23, 2009 at 12:33 PM, G=E1bor Stefanik
> <netrolller.3d@gmail.com> wrote:
>> On Mon, Feb 23, 2009 at 6:51 PM, Luis R. Rodriguez <mcgrof@gmail.com=
> wrote:
>
>>> If we enable passive scan on channels 12-14 on the world regdomain
>>> (which it seems we should) that would cure this issue as well.
>>> Thoughts?
>>>
>>> =A0Luis
>>>
>>
>> What if the user wants to host an AP? What if "MyNET123" is ad-hoc o=
r
>> mesh? What if the user needs packet injection?
>
> Then if you see an AP around you you can determine you can beacon as
> well (did you see the new beacon hint patches I sent?) otherwise you
> need crda and you need to set your regdomain. Mind you AP support
> didn't got in for mac80211 drivers until 2.6.29 where OLD_REG is stil=
l
> default. The patch in question is for 2.6.30 and it not about
> _removing_ OLD_REG, its about not making it default, the patch
> suggests removal for 2.6.31.
>
> Also remember that hostapd supports setting the country from the
> configuration file as well.
>
>> Forcing the initial
>> regdomain to world is not a good idea.
>
> OLD_REG implies just that -- its old, meaning we're moving on to new
> things. The new strategy we decided on was to not rely on static
> regulatory domains in the kernel so so the only reasonable option in
> the absence of location information is to default to world.

I mean forcing the initial regdomain to world even when CRDA is
available - the only way to set the regdomain on boot without the
modparam on an existing distro is editing init scripts, which changes
depending on the distro. (I've seen distros which didn't allow direct
editing of init scripts, instead they were auto-generated on each
software change!) A distro upgrade is not always an option.

>
>> Channel 13 was also just an
>> example, it could be an 5GHz channel as well.
>
> Sure, and I posted a new set of patches which enable 5 GHz passive sc=
an as well.

On all channels that may be available somewhere, or is it just an inter=
section?

>
> =A0Luis
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
