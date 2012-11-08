Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54365 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab2KHWvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 17:51:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1857530eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 14:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XzDrTt1azuEdZTUkVgP0LeLB5Jynb6h_h5N-+_ArCGGQ@mail.gmail.com>
References: <1351709571-23301-1-git-send-email-mcgrof@do-not-panic.com>
 <CAGRGNgXyyvpSfFqd+L6J166Lfu7yfWc8-zMwpTMxLzFY+Qs0nA@mail.gmail.com> <CAB=NE6XzDrTt1azuEdZTUkVgP0LeLB5Jynb6h_h5N-+_ArCGGQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 9 Nov 2012 09:51:10 +1100
Message-ID: <CAGRGNgUi9Pagf0Kq4m0w_hfBTA1AW5pVAeaq-UC_1jyYfujNyw@mail.gmail.com> (sfid-20121108_235149_447826_01B27B54)
Subject: Re: [PATCH] carl9170: kill MODULE_VERSION
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Fri, Nov 9, 2012 at 4:46 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Oct 31, 2012 at 11:36 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Luis,
>>
>> On Thu, Nov 1, 2012 at 5:52 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>>
>>> This is pretty pointless. Lets kill this to stop people from
>>> thinking that its actually used. Maybe we should go on
>>> a crusade and kill this completely from the kernel.
>>
>> I'm sure that there are a multitude of places where MODULE_VERSION is
>> unnecessary, but killing it from the entire kernel simply won't
>> happen.
>
> Easily, nope, hard yes.

Completely agree.

>> I know that in the SCSI subsystem some of the
>> vendor-maintained drivers use this to keep track of exactly which
>> version is running on a given kernel.
>
> What's this "vendor-maintained" thing?

I must have written that while tired and consequently mangled my point.

I meant that they're maintained like the brcm[sf]mac drivers - i.e. by
the manufacturer of the hardware - but with a thicker layer of
corporate enterprise stuff between us mortals in the kernel
development community and them. I bring this up because the "average"
patchset for these drivers reads like a new release of a piece of
software "this is version 13.3.7 here's what's changed, and following
is it split into patches" (Example patchset from Emulex [1]) rather
than a set of patches and I recall that there's been some friction in
the past between how they want to do things: distributing their
drivers separately for the distros they support (see [2]) as well as
sending it upstream; and what we consider to be the right way to do
things.

That said, I haven't seen any real conflict over this in the SCSI
subsystem recently, so maybe my fears are based on behaviours from the
past. IIRC most of the hardware manufacturers are realising that they
have to follow the "Linux way" to get their stuff out there, but I'm
pretty sure there's still at least one manufacturer who is still doing
the absolute minimum they have to to make their throw-it-over-the-wall
strategy acceptable to upstream.

>> (Why not use kernel releases? not sure, probably a combination of user-interface, distro backporting
>> and internal systems.)
>
> Exactly, I'm alluding there's better ways to do this and to reflect
> provenance better, but also by prioritizing upstream development.

For what it's worth, I completely support your plan and agree that
there are much better ways to do things (e.g. backporting with
compat-drivers) I just want you to be aware that there are still some
companies out there which are still very wedded to the "old" ways of
doing things and have "good" reasons for doing things that way.

[1] : http://marc.info/?l=linux-scsi&m=135170911826107&w=2
[2] : http://www.emulex.com/downloads/emulex/cnas-and-hbas/drivers/linux.html

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
