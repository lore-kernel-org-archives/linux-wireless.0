Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1HVQek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 12:34:40 -0400
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: Dan Williams <dcbw@redhat.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Date: Mon, 22 Aug 2011 11:37:03 -0500
In-Reply-To: <4E526487.1030609@broadcom.com>
References: <20110814121646.GA5188@stt008.linux.site>
	 <4E4A5641.4020604@broadcom.com> <1313509211.2065.36.camel@dcbw.foobar.com>
	 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
	 <4E4E73F4.4040105@broadcom.com> <20110819152140.GA7506@stt008.linux.site>
	 <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
	 <4E52297D.9090301@broadcom.com> <20110822112737.GA5936@stt008.linux.site>
	 <4E525235.7060501@broadcom.com>
	 <CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
	 <4E526487.1030609@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1314031025.16366.7.camel@dcbw.foobar.com> (sfid-20110822_183443_384857_90074A23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-22 at 16:15 +0200, Roland Vossen wrote:
> Hi,
> 
> >> Would you happen to know if with kernel 2.6.39, the brcmsmac driver was
> >> active as well (and not a different driver) ?
> >
> > I expressely used the brcmsmac because it was newer, easier to setup
> > than the others... and it's open source :-)
> 
> just to make sure: so you were already using brcmsmac in 2.6.39 ?

Quite often kernel rfkill/platform drivers need updates for new
hardware; OEMs apparently change BIOS randomly and often break things
like the keycodes that BIOS sends for rfkill, or the WMI/ACPI events
that are triggered for rfkill, or the locations where rfkill status is
stored.  So if rfkill looks to be the culprit, we should probably verify
that the laptop is well supported by the kernel rfkill and platform
drivers (like hp-wmi, dell-laptop, acer-laptop, thinkpad-acpi, etc).

Dan

