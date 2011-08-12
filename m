Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1HLS7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 14:59:21 -0400
Subject: Re: [PATCH 01/14] staging: brcm80211: use wait queues instead of
 semaphores in wl_cfg80211.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Henry Ptasinski <henryp@broadcom.com>
In-Reply-To: <4E45771C.7090400@broadcom.com> (sfid-20110812_205545_370176_D626E9A4)
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
	 <1313156101-16817-2-git-send-email-arend@broadcom.com>
	 <CACna6rzmaxzezN-OPTLvXyFOZOsoq6XCds4P-FOEz27FzJz+Jg@mail.gmail.com>
	 <4E455877.6090901@broadcom.com>  <4E45771C.7090400@broadcom.com>
	 (sfid-20110812_205545_370176_D626E9A4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 20:59:12 +0200
Message-ID: <1313175552.4022.22.camel@jlt3.sipsolutions.net> (sfid-20110812_205923_986014_A3960465)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-12 at 20:55 +0200, Arend van Spriel wrote:

> >>> +               } while ((e = brcmf_deq_event(cfg_priv)));
> >> if (((((care_coding_style)))))
> >> fix();
> >>
> >> :-)
> >>
> > I assume you refer to the indents above. Not sure what exactly happened
> > there, but the patch email as I received it looks. Could it be a mail
> > reader issue?
> >
> > Gr. AvS
> 
> A colleague pointed out you probably meant the while condition. The 
> extra braces may be there because an assignment is done, but in this 
> case it does not make much sense.

Doesn't gcc warn if you don't have two parentheses?

johannes

