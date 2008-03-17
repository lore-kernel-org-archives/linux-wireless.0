Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYCQVLa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 17:11:30 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205761758.1614.79.camel@johannes.berg>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 (sfid-20080317_133616_002306_499F1E28)  <1205761758.1614.79.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:06:45 -0400
Message-Id: <1205788005.9583.4.camel@localhost.localdomain> (sfid-20080317_220527_197898_D890D13E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-17 at 14:49 +0100, Johannes Berg wrote:
> > >  Huh ok. But how would the WEP legacy station be able to determine that?
> > 
> > Legacy user get the key written on 'positit' yellow paper :).
> 
> Heh yeah.
> 
> > >  Or does it just try to use WEP and succeed? TBH, I was unaware that this
> > >  existed, this does make it a bit more of a problem than I thought then.
> > >
> > 
> > >  >
> > >  > On second thought is that AP has only TX group key while STA has only
> > >  > RX group key so I
> > >  > m not seeing here any need for flag.
> > >
> > >  Hm, well, I didn't really want to require the driver to keep track of
> > >  the current operating mode, so that's why I used 00:...:00 vs. FF:...:FF
> > >  for the group keys.
> > 
> > Isn't if on integer faster then comparing 6 bytes?
> 
> Probably. Does it matter though? Setting keys isn't going to be
> performance critical in any way.
> 
> > >  Is that really done though? I mean, does wpa_supplicant not also use
> > >  encodeext for WEP keys?
> > >
> > Unfortunately yes.
> 
> So that doesn't really help us either way, no?
> 
> > First of all we don't need 4 keys per station but for the whole
> > system. 
> 
> Not sure I understand this. You need pairwise (per-station) keys as well
> as four default keys, no?
> 
> > Even in AP mode with multiple SSID meaning multiple security
> > setting you cannot distinguish between networks in static WEP key
> > setting so 4 is enough.
> 
> Not sure I get what you're thinking here.
> 
> > Beside that you need place holder for group key. They might be
> > multiple groups key in case of multiple SSIDs in AP mode, iwlwifi
> > doesn't support it in HW but in general it is possible.
> 
> Well, no, because we can add multiple keys with a zeroed MAC address,
> since we have the local MAC address in there as well. Also, in an AP,
> these are only used for TX so it doesn't matter since mac80211 does the
> key selection completely on its own.
> 
> > We need a flag in set_key which says whether the WEP key is static or not.
> 
> Let's actually try to gather all the cases first.
> 
> Is this it?
> 
>  * TKIP/CCMP/WEP group or pairwise key
>  * WEP legacy ('static') key

So the problem with this is, how does Dynamic WEP work here?  Dynamic
WEP uses 802.1x/EAP to rekey stations periodically just like
WPA[2]-Enterprise, but of courses uses WEP only.  It's not "static" WEP
as you guys have been talking about it (you could call static WEP
"WEP-PSK" if you like).

The problem here is that with WEXT, there's not a good way to
distinguish between the two.  Both static & dynamic WEP might look the
same to the driver when the call comes through SIWENCODE/SIWENCODEEXT.
So you've got to be careful here classifying all WEP key requests as
static.

Dan

> where the first is completely covered by what we have now and the
> assumption is that if only WEP keys are present then it'll be a legacy
> WEP key?
> 
> johannes

