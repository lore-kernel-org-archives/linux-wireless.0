Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab3KKRUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 12:20:37 -0500
Message-ID: <1384190436.4271.31.camel@dcbw.foobar.com> (sfid-20131111_182045_355892_04C04AED)
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for
 p2p connection.
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>, Jouni Malinen <j@w1.fi>,
	"Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 11 Nov 2013 11:20:36 -0600
In-Reply-To: <1384187186.14334.39.camel@jlt4.sipsolutions.net>
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
	 <1383230593.14302.1.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
	 <1383233115.14302.2.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
	 <52729681.5020004@broadcom.com>
	 <26F3B0343EE4744AA14EEEF9E1E534511F7A8160@aphydexd01a>
	 <5273A784.4040900@broadcom.com> <20131102073319.GA3507@w1.fi>
	 <5274D5DC.1090508@broadcom.com>
	 <1384187186.14334.39.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 17:26 +0100, Johannes Berg wrote:
> On Sat, 2013-11-02 at 11:37 +0100, Arend van Spriel wrote:
> 
> > > Currently, there is no way for wpa_supplicant to clearly indicate to the
> > > driver that it is about to run through number of quick operations
> > > (offchannel Action frame exchange for GO Negotiation, single channel
> > > scan, WPS association + EAPOL exchange, data connection association +
> > > 4-way handshake). The driver can guess that this is happening (or could
> > > use really ugly hacks to see what Action frames are exchanged and
> > > determine next likely operation based on that) and as such, would not
> > > know how to configure the firmware to avoid background scans for the
> > > station interface during this full sequence.
> > 
> > I wanted this API primarily to avoid drivers doing that kind of hacks so 
> > I agree. It was intended to avoid extra latencies during IP connection 
> > setup, which is probably happening right after the group formation. So I 
> > recommend the connection managers to use this API. I think Dan Williams 
> > did some initial implementation testing in NetworkManager and had some 
> > concerns. I forgot about them completely so not sure how that ended.
> > 
> > > While the background scan should in most cases not completely break the
> > > process even with inconvenient timing (or well, hitting one in middle of
> > > the three frame GO Negotiation would have potential to time out that
> > > exchange), it would be nice if this common sequence could be optimized
> > > to avoid extra latencies and to be more robust in general since there is
> > > a 15 second timeout for group formation and quite a bit shorter timeouts
> > > in practice for the individual operations within the sequence.
> > 
> > I guess the decision is for Johannes to take, but I see your point.
> 
> I think after this long discussion we all finally understand the concern
> and use case - that really could have been explained in the patch
> message.
> 
> Anyhow, I think that the critical protocol API is still a bad fit
> because it currently only allows
>  (1) a single user of the API at a time, so e.g. connman using it for
> DHCP on a
>      P2P group interface while wpa_s is using it for GO negotation would
> break
>  (2) changing that is probably not too difficult technically, but the
> question is
>      how multiple concurrent protocols should behave and if anything
> else has
>      really started using this yet

I've had patches for NetworkManager for a while for this, I had
developed them in May 2013 which then resulted in my replies to
"cfg80211: introduce critical protocol indication from user-space".  I
posted about your problem #1, and Arnd's reply at the time was "I am not
fully convinced there will be a need for multiple protocols."  Perhaps
that need has now become more apparent?

Dan

