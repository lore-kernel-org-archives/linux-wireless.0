Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:56845 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYDOJUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 05:20:44 -0400
From: bruno randolf <bruno@thinktube.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: AR5K_INT_SWBA can't generate interruption for sending beacons
Date: Tue, 15 Apr 2008 10:59:05 +0200
Cc: linux-wireless@vger.kernel.org,
	"cao jing" <caojing.china@gmail.com>
References: <9f33c5230804142124g3c8f4a0ai28a6b5117e1034c9@mail.gmail.com> <200804151036.55216.hs4233@mail.mn-solutions.de>
In-Reply-To: <200804151036.55216.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804151059.06119.bruno@thinktube.com> (sfid-20080415_102055_244552_FE3433E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 April 2008 10:36:55 Holger Schurig wrote:
> > I'm working on mac80211 and ath5k. I found that the
> > AR5K_INT_SWBA interruption can't be generated. So I can't send
> > beacons by this interruption. Anyone knows what's going on
> > with it?

the current code in wireless-testing uses SWBA not to send beacons but to keep 
track of the next beacon time NBTT. this is necessary to work around certain 
hardware limitations. once configured, the beacons are sent automatically by 
the hardware at the right time. of course it would be possible to change the 
code to generate a new beacon at every SWBA but as long as the beacon 
contents don't change very often i don't see the point of doing so.

> ath5k didn't make it yet to wireless-testing. That is the git
> tree for all wireless stuff that finally will make it into
> mainline Linux. See http://linuxwireless.org for more detail.

i don't know how you come to that conclusion - ath5k *is* in wireless-testing 
and there are a few people working on it.

bruno
