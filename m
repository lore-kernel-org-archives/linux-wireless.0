Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48883 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZC3RyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:54:11 -0400
Received: by ewy9 with SMTP id 9so2191198ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 10:54:08 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rfkill: rewrite
Date: Mon, 30 Mar 2009 19:54:06 +0200
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
References: <1238349195.24972.5.camel@johannes.local> <200903301039.52153.inaky@linux.intel.com> <1238435143.5970.21.camel@johannes.local>
In-Reply-To: <1238435143.5970.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903301954.07008.IvDoorn@gmail.com> (sfid-20090330_195415_327764_81E07CD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009, Johannes Berg wrote:
> On Mon, 2009-03-30 at 10:39 -0700, Inaky Perez-Gonzalez wrote:
> > On Monday 30 March 2009, Johannes Berg wrote:
> > >
> > >  * wimax
> > >    -> need help, seems to report rfkill states to input device?
> > >       don't understand
> > 
> > Not really. 
> > 
> > What it does is if the device exposes a hw rfkill key, export that 
> > key as an input device, as well as using it to report the state
> > change. 
> > 
> > So there are three main entry points:
> > 
> > wimax_report_rfkill_hw() -- device driver report to stack
> >   
> >    device reports a change in the hw rfkill key; switch the radio to
> >    whichever state AND report a key event through the input layer
> 
> But reporting the key through the input layer is wrong, afaict.

Why because it combines it with switching the radio?
In rt2x00 all key events are going through the input layer as well,
because it has no influence on the radio state of the device.
(In other words, you can still happily send and receive all
the data you want regardless of the key state).

Ivo
