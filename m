Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HZIaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:30:39 -0400
Message-ID: <1345969836.3622.4.camel@jlt4.sipsolutions.net> (sfid-20120826_103043_696198_77584419)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 26 Aug 2012 10:30:36 +0200
In-Reply-To: <CAB3XZEfTEz5U0Tu7H-S0ZzDZvUMBdfMgjx6+oS3yF+LaudznjA@mail.gmail.com> (sfid-20120826_102847_800178_D01E8625)
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1345800585.4503.8.camel@jlt3.sipsolutions.net>
	 <CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com>
	 <1345968623.3622.3.camel@jlt4.sipsolutions.net>
	 <CAB3XZEfTEz5U0Tu7H-S0ZzDZvUMBdfMgjx6+oS3yF+LaudznjA@mail.gmail.com>
	 (sfid-20120826_102847_800178_D01E8625)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-26 at 11:28 +0300, Eliad Peller wrote:

> >> this scenario (deauth after disassoc) also sounds pretty unlikely...
> >
> > It seems that it happens when you ask the supplicant to "disconnect" via
> > the CLI.
> >
> at least in my setup issuing a "disconnect" via the CLI ends only with
> a deauth (as the respective code in wpa_supplicant/ctrl_iface.c seems
> to call only wpa_supplicant_deauthenticate())

Hm. Maybe it was removing the interface then, or something. I don't
remember, but Ilan said he had a way to trigger this.

In any case, it seems we should handle it in some way?

johannes

