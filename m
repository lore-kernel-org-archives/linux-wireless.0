Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53750 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1LTIhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 03:37:31 -0500
Received: by dajs34 with SMTP id s34so3869621daj.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 00:37:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324312896.3414.16.camel@jlt3.sipsolutions.net>
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	<1324310130.3414.3.camel@jlt3.sipsolutions.net>
	<CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com>
	<1324312896.3414.16.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Dec 2011 09:37:31 +0100
Message-ID: <CAGXE3d9izM_cu=FpoYfLR1cx=tn+3BPMi9d7XEBfG-bkHR1oRA@mail.gmail.com> (sfid-20111220_093735_116632_97A5C4CC)
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for relayed frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 5:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-12-19 at 17:36 +0100, Helmut Schaa wrote:
>
>> >> We could also reuse the TID used by the source STA but I guess we should
>> >> always classify frames according to our own mapping instead of relying
>> >> on the associated STAs to do the right thing.
>> >
>> > Not sure that's useful, since we classify almost nothing anyway.
>>
>> Currently we only use the IPv4 DSCP field for assigning TIDs to
>> frames. That seems to be sufficient for VOIP traffic at least.
>>
>> > If this was somehow hooked up to tc or iptables that would be
>> > more useful I guess?
>>
>> Agreed. This would make sense in the future but I don't feel like
>> implementing this right now.
>>
>> So, you'd prefer to just copy over the TID as used by the source
>> STA (via the priority+256 hack maybe)?
>
> Seems simpler to me really, at least right now and as default. Not sure,
> maybe other people have more opinion? :)
>
> I just don't expect anyone to hack the kernel for their local policy,
> and using what the STA wanted seems OK? If you run wifi networks you
> kinda trust them already anyway :)

Fine with me. I'll change the patch to keep the priority the STA used ...
Helmut
