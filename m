Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tjworld.net ([67.18.187.6]:38450 "EHLO tjworld.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbZCXVWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 17:22:24 -0400
Subject: Re: iwl3945: Don't queue rfkill_poll work when module is exiting
From: TJ <ubuntu@tjworld.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903241851.11949.helmut.schaa@gmail.com>
References: <1237909459.5365.16.camel@hephaestion>
	 <200903241851.11949.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 21:22:19 +0000
Message-Id: <1237929739.5365.21.camel@hephaestion> (sfid-20090324_222230_084524_5BD1C481)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 18:51 +0100, Helmut Schaa wrote:
> Am Dienstag, 24. M=C3=A4rz 2009 schrieb TJ:
> > Tim Gardner suggested I forward this as a possible stable-release
> > update. I found the problem in our current Ubuntu Jaunty tree - iwl=
wifi
> > version 1.2.26k. What follows is a copy of the patch for Jaunty
> > (2.6.28).
>=20
> The patch that introduced the rfkill polling did not hit mainline yet=
=2E It
> should pop up in 2.6.30, hence this patch is not needed for any stabl=
e
> series.
>=20
> I wasn't able to reproduce the issue by unloading iwl3945 here. Any h=
ints
> on how to reproduce this issue?

lspci -nn -s 06:00.0
06:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 3945A=
BG [Golan] Network Connection [8086:4222] (rev 02)

With the interface active and in use do:

sudo modprobe -r iwl3945

Approximately 2 seconds later the PC locks solid and requires a
power-off button restart.

Confirmed by another of our kernel team:

https://launchpad.net/bugs/345710

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
