Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59843 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3KOMBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 07:01:47 -0500
Received: by mail-lb0-f170.google.com with SMTP id z5so2654501lbh.29
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 04:01:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=pZ_v+kupuU=wVmWLYp7_9w-uEerrJUJkXfZqh1kxiUOw@mail.gmail.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
 <1384378173.28806.22.camel@jlt4.sipsolutions.net> <CALhHN=r4y+JDw9_i9FdKwNoHgic+bvkMJRpYwnaXoSK519Metw@mail.gmail.com>
 <CALhHN=o-LQfXuyujFOj6A7hzE0mBbC5Q6r3ByL6APJffOx4sHQ@mail.gmail.com>
 <20131114144638.GF19070@garbanzo.do-not-panic.com> <CALhHN=pZ_v+kupuU=wVmWLYp7_9w-uEerrJUJkXfZqh1kxiUOw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 15 Nov 2013 13:01:25 +0100
Message-ID: <CAB=NE6WsqX1k+jP0FchheNDHWAPwJarm+bcq4A4uoKTD14cWOw@mail.gmail.com> (sfid-20131115_130150_727161_D038E9CF)
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:37 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> 1) request CAC
> 2) mac80211 will call driver radar detection (ETSI) and will start cac
> timer (60s)
> 3) after 40 seconds we will change regdom and dfs_region (eg. from
> ETSI -> FCC) - tested using iw reg set US
>
> Currently we will not cancel CAC and will mark channels as
> DFS_AVAILABLE after 1 minute.
> So, probably we will need cancel_radar_detection() callback that will
> cancel mac80211 timer here when cac_started and regulatory_update()
> and different dfs_regions.
>
> 4) CAC end and we set DFS_AVAILABLE state
> 5) we start beaconning (even we do radar_detection for FCC only for
> about 20 seconds)
>
> This is probably rare case when we will change dfs_region between
> start_cac() and can_beacon() - so I am not sure we have to handle
> this?

Ah great point. I had not considered this. The regulatory code I added
to quiesce would take care of this, it'd force wdev's to tear down any
active sessions they have. That is provided I convince Johannes this
is indeed necessary.

  Luis
