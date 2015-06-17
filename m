Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbbFQOcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 10:32:36 -0400
Message-ID: <1434551555.3952.8.camel@redhat.com> (sfid-20150617_163241_825246_9C8D3D80)
Subject: Re: [PATCH v2] Add new mac80211 driver mwlwifi.
From: Dan Williams <dcbw@redhat.com>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Date: Wed, 17 Jun 2015 09:32:35 -0500
In-Reply-To: <9c9237415bfe49568467f9795dc08111@SC-EXCH02.marvell.com>
References: <2127ea28a2a74cd6a89d45b88caf06cb@SC-EXCH02.marvell.com>
	 <1434526059.1884.7.camel@sipsolutions.net>
	 <7e061b3712f4408284917b5a5b4d3813@SC-EXCH02.marvell.com>
	 <1434529677.1884.9.camel@sipsolutions.net>
	 <9c9237415bfe49568467f9795dc08111@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 08:34 +0000, David Lin wrote:
> > Johannes Berg wrote:
> > 
> > On Wed, 2015-06-17 at 08:07 +0000, David Lin wrote:
> > 
> > > > Also, you probably really should have two header files - one for the
> > > > firmware structs and one for the driver structs - especially since
> > > > you seem to be confusing the two!
> > > >
> > > As mentioned before, this is current interface with F/W, and this F/W
> > > is used by other marvell's drivers, I can't change it.
> > 
> > You're misunderstanding. I'm not asking you to change the interface. I'm just
> > asking you to make sure you know which part is firmware interface and which
> > isn't. Clearly, pointers *cannot* be firmware interface - if there's something
> > "cookie-like" that you use as pointers you at least need to make sure you know
> > how long this field is (32 or 64 bits)...
> >
> Yes, we know this kind of issue. We will enhance it in the future.
> > 
> > > All structures defined in this file are related to F/W commands, it
> > > should be better let them be defined in this file.
> > 
> > Given your own confusion on what's firmware API and what isn't, I'm not so
> > sure about that ...
> >
> I am sure all structures defined in this file is related to firmware command.

They may well be related, but that doesn't necessarily mean that the
driver side cannot be clearer about what fields of a struct are actually
read by the firmware, and what fields are private to the host
implementation as a data stash (eg, 'priv'-type stuff).  Redoing the
structs like Johannes suggested originally would make that
crystal-clear...

Dan

