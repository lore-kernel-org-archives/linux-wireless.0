Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:42614 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429AbZGQLR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 07:17:29 -0400
Received: by bwz28 with SMTP id 28so662469bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 04:17:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
Date: Fri, 17 Jul 2009 12:17:26 +0100
Message-ID: <3ace41890907170417s7aae2c5di6a2381908ee8d85e@mail.gmail.com>
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	till.kamppeter@gmail.com, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I thought the reason for using GeoClue is to cater for frequent
travellers who can cross timezone (and not neccesarily reset their
laptop's computer/clock for it)? So it is orthogonal to one-off static
setup where the computer mostly stay in the same country/location. Is
there an iw/cfg80211 interface/field for regulatory info? AFAIK there
isn't in wext, but that's on its way out and probably not important...

On Fri, Jul 17, 2009 at 2:10 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> The GSoC project to integrate GeoClue to GNOME and eventually send
> regulatory hint information to the kernel [1] will not be completed
> through GSoC. Since I am not sure if the student will be interested in
> following up on this project idea outside the scope of GSoC I'm
> looking for advice to better get an idea of what it is exactly we
> should be looking forward to change to get information to the kernel
> to enhance regulatory support using GeoClue. At the very least I'd
> like to come to some conclusion as to where it is best to put software
> to send information to the kernel to help distributions.
>
> The current best alternative I've seen is to read the current timezone
> information and extract the country from that. That is how John
> implemented it for Fedora. This may be enough but GeoClue should
> provide better accuracy. All we need in the kernel is to determine the
> country you are on. The user can obviously set this themselves during
> a distribution install, but it may make sense to just use GeoClue for
> this. Under the assumption that using GeoClue is the way to go how
> should we do this?
>
> For the GSoC project I was initially suggesting for Network Manager to
> get GeoClue integration and then have Network Manager send the
> regulatory hint once a country was determined through either user
> input or through GeoClue magic. After some discussions with Jouni
> about this he convinced me this may not be the best place for this. So
> if not Network Manager, where? Do we want a GNOME location aware panel
> under System->Administration? Is it as simple as that? If not are
> there any other suggestions?
>
> If you fwd this to another list for discussion please do CC me.
>
> [1] http://wireless.kernel.org/en/developers/GSoC/2009/GeoClue_regulatory
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
