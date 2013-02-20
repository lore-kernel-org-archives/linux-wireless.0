Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:54669 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738Ab3BTBAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 20:00:44 -0500
Received: by mail-we0-f172.google.com with SMTP id x10so6132022wey.31
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 17:00:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361197194.8555.17.camel@jlt4.sipsolutions.net>
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com> <1361197194.8555.17.camel@jlt4.sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Feb 2013 12:00:23 +1100
Message-ID: <CAGRGNgWLHTV2T9WFAGtB8Wz4=zNcrCUkHVFJX5Q=kdbFLTSKOQ@mail.gmail.com> (sfid-20130220_020049_179286_FCC48DD8)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Feb 19, 2013 at 1:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-02-16 at 11:22 -0800, Thomas Pedersen wrote:
>> Increases mac80211 memory use by about 95K.
>>
>> At least Ubuntu, Debian, and Arch Linux already enable
>> this in their default kernels.
>
> *shrug*
>
> I guess I don't really see a problem with this, although only a small
> subset of drivers really supports it. Anyone really wanting to build for
> a small system will probably turn it off anyway.
>
> OTOH, if distros enable it, I also don't see much point in changing
> it ;-)
>
> What might be interesting is for drivers to somehow indicate they
> support it? But you wouldn't necessarily want drivers to "select MESH",
> so it'd probably have to be something like not allowing mesh to be
> turned on if no driver is turned on that has it? But that makes it
> complicated again, so it's all probably not worth it.

IIRC, the standard way to do things like that is something like:

config HAVE_MESH_DRIVER
    default n

config RANDOM_DRIVER
    select HAVE_MESH_DRIVER

config MESH
    default y if HAVE_MESH_DRIVER

That way it's default on if drivers are selected which have mesh
support but still user selectable (either to disable or if out-of-tree
drivers want it).

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
