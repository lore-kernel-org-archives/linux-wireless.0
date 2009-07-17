Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44171 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964910AbZGQQeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:34:07 -0400
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
From: Bastien Nocera <hadess@hadess.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	till.kamppeter@gmail.com
In-Reply-To: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 17:33:47 +0100
Message-Id: <1247848427.8139.4386.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-16 at 18:10 -0700, Luis R. Rodriguez wrote:
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

Adding more preferences certainly isn't the solution.

One of the problems you'd encounter would be trying to get information
about which country you're in, which might sometimes require a network
to get.

You get a bit of a chicken/egg problem. How can I get online to get my
location given that I can't get online because my wireless card's been
restricted to channels outside my reach.

How does John's code react when the timezone changes? How do you get
online to get the country when the network isn't available because of
previous restrictions? Do you need to change the regulatory hint in the
kernel as soon as you know the new position? Is it saved and cached
somewhere so you don't need to pound the hardware on each reboot?

Let us know...

Cheers

