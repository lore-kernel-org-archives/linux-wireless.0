Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:47801 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897AbZGQBKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 21:10:25 -0400
Received: by mail-yx0-f184.google.com with SMTP id 14so911945yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 18:10:25 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 18:10:05 -0700
Message-ID: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
Subject: Using GeoClue to send a Linux wireless regulatory hint
To: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: till.kamppeter@gmail.com, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GSoC project to integrate GeoClue to GNOME and eventually send
regulatory hint information to the kernel [1] will not be completed
through GSoC. Since I am not sure if the student will be interested in
following up on this project idea outside the scope of GSoC I'm
looking for advice to better get an idea of what it is exactly we
should be looking forward to change to get information to the kernel
to enhance regulatory support using GeoClue. At the very least I'd
like to come to some conclusion as to where it is best to put software
to send information to the kernel to help distributions.

The current best alternative I've seen is to read the current timezone
information and extract the country from that. That is how John
implemented it for Fedora. This may be enough but GeoClue should
provide better accuracy. All we need in the kernel is to determine the
country you are on. The user can obviously set this themselves during
a distribution install, but it may make sense to just use GeoClue for
this. Under the assumption that using GeoClue is the way to go how
should we do this?

For the GSoC project I was initially suggesting for Network Manager to
get GeoClue integration and then have Network Manager send the
regulatory hint once a country was determined through either user
input or through GeoClue magic. After some discussions with Jouni
about this he convinced me this may not be the best place for this. So
if not Network Manager, where? Do we want a GNOME location aware panel
under System->Administration? Is it as simple as that? If not are
there any other suggestions?

If you fwd this to another list for discussion please do CC me.

[1] http://wireless.kernel.org/en/developers/GSoC/2009/GeoClue_regulatory

  Luis
