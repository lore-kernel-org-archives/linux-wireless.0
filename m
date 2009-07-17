Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:63069 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbZGQQKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:10:50 -0400
Received: by pzk35 with SMTP id 35so683448pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890907170417s7aae2c5di6a2381908ee8d85e@mail.gmail.com>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
	<3ace41890907170417s7aae2c5di6a2381908ee8d85e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 09:10:30 -0700
Message-ID: <43e72e890907170910j88b466ej381046bf7df001c2@mail.gmail.com>
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	till.kamppeter@gmail.com, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 4:17 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> I thought the reason for using GeoClue is to cater for frequent
> travellers who can cross timezone

No, you use it for whatever you want. For wireless we want it to get
the country so the user does not have to bother with setting the
regulatory domain themselves.

> (and not neccesarily reset their
> laptop's computer/clock for it)?

That seems to be just one use for GeoClue.

> So it is orthogonal to one-off static
> setup where the computer mostly stay in the same country/location.

Sure, a static computer still can use location information and I won't
get into the use cases for that outside the scope of wireless. As far
as distributions are concerned it would still be nice to provide the
country the user is in to the kernel even for statically placed
computers and not have the user set this.

The idea is to just automate informing the kernel of your country and
using the best resources possible to do this.

> Is
> there an iw/cfg80211 interface/field for regulatory info?


Yes. See iw documentation about this [1], wpa_supplicant also has
support for this as well.

[1] http://wireless.kernel.org/en/users/Documentation/iw#Updating_your_regulatory_domain

> AFAIK there isn't in wext,

No and there won't be.

> but that's on its way out and probably not important...

Wireless extensions is not going to be removed, we just stop advancing
it and now that we have a good replacement API (cfg80211) we push
driver developers to use it for new drivers to be merged.

  Luis
