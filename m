Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19504 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZAORpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:45:14 -0500
From: Paul Moore <paul.moore@hp.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Thu, 15 Jan 2009 12:45:05 -0500
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901141736.43805.paul.moore@hp.com> <496E974E.1040806@gmail.com>
In-Reply-To: <496E974E.1040806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901151245.05494.paul.moore@hp.com> (sfid-20090115_184521_373418_EC3E1002)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 8:54:22 pm Justin P. Mattock wrote:
> Paul Moore wrote:
> apologize for the slow response
> (had to do some external activities);

No problem, I've got a day job too :)

> > NOTE: the domain mapping configuration only controls how outbound
> > network traffic is labeled on-the-wire; it "maps" the
> > LSM/SELinux "domains" to a specific labeling protocol
> > configuration, e.g. all apache_t traffic should be labeled with
> > CIPSO DOI 3 while all firefox_t traffic should not be labeled at
> > all.

...

> > I think what you mean to type is the following:
> >
> >  # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
> >        label:system_u:object_r:netlabel_peer_t:s0
> >
> > ... note there is no "domain" argument, that only exists
> > for "netlabelctl map ..." commands.
> >
> > NOTE: if you really want to get fancy you can create new SELinux
> > domains for each type of media and add NetLabel configurations for
> > those new domains.  Imagine you create a new "internet_radio_t"
> > domain/type and only allow the "netplayer_t" domain (yeah, I made
> > that up but you get the point) access to network traffic labeled
> > with internet_radio_t. You would then use the following command to
> > label your incoming traffic with NetLabel:
> >
> >  # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
> >        label:system_u:object_r:internet_radio_t:s0
> >
> > NOTE: you can also skip the "interface:wlan0" argument and just
> > use "default" instead if you want the configuration to apply to all
> > your network interfaces; although bear in mind that the "default"
> > configuration can be overridden by the interface specific
> > configurations.
>
> Alright, I thought you could use the map option for unlbl.

Yes, you can use configure the LSM/SELinux domain mapping to send 
unlabeled/"unlbl" packets (the default configuration maps all outbound 
traffic to "unlbl") but since you only really care about inbound 
traffic you can ignore the "map" option.

-- 
paul moore
linux @ hp
