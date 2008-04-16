Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:58923 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbYDPInO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 04:43:14 -0400
From: bruno randolf <bruno@thinktube.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: AR5K_INT_SWBA can't generate interruption for sending beacons
Date: Wed, 16 Apr 2008 10:43:01 +0200
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, cao jing <caojing.china@gmail.com>
References: <9f33c5230804142124g3c8f4a0ai28a6b5117e1034c9@mail.gmail.com> <200804151059.06119.bruno@thinktube.com> <20080416060109.GG15053@jm.kir.nu>
In-Reply-To: <20080416060109.GG15053@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804161043.01769.bruno@thinktube.com> (sfid-20080416_094327_079900_5AED4CB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 08:01:09 Jouni Malinen wrote:
> On Tue, Apr 15, 2008 at 10:59:05AM +0200, bruno randolf wrote:
> > the current code in wireless-testing uses SWBA not to send beacons but to
> > keep track of the next beacon time NBTT. this is necessary to work around
> > certain hardware limitations. once configured, the beacons are sent
> > automatically by the hardware at the right time. of course it would be
> > possible to change the code to generate a new beacon at every SWBA but as
> > long as the beacon contents don't change very often i don't see the point
> > of doing so.
>
> In AP mode, beacon payload changes for _every beacon_ unless you use
> DTIM Period of 1. In order to make power saving work correctly, the
> drivers need to update the beacon data for every beacon.

thats's true - i was thinking of IBSS mode first of all since AP mode is not 
supported yet by ath5k. actually also in IBSS mode the beacon contents would 
have to change for power saving, this is also not implemented yet.

bruno
