Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25599 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbYDCGlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 02:41:36 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] libertas: convert libertas driver to use an event/cmdresp queue
Date: Thu, 3 Apr 2008 08:38:41 +0200
Cc: linux-wireless@vger.kernel.org
References: <200803271700.58477.hs4233@mail.mn-solutions.de> <200804011439.54618.hs4233@mail.mn-solutions.de> <1207191923.9250.6.camel@localhost.localdomain>
In-Reply-To: <1207191923.9250.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804030838.41618.hs4233@mail.mn-solutions.de> (sfid-20080403_074140_210531_DFE0D263)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> find another machine with a CF slot.  No amount of ifconfig or
> iwconfig magic will help it, the card accepts a TX packet with
> if_cs_send_data() and then apparently never sends an interrupt
> to say the TX is done.

Hmm, that is weird.

Have you thought about some band-aid, e.g. a timer that fires one 
the IRQ doesn't come and then re-send the tx packet?  Maybe ...

> The driver then does the RSSI thing to poke the firmware, which
> of course times out, and then all is lost.

... the RSSI thing is wrong here.
