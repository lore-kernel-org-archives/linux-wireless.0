Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay05-dus.antispameurope.com ([94.100.134.205]:35267 "EHLO
	mx-relay05-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbaBQRgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 12:36:03 -0500
From: "Kretschmer, Mathias" <mathias.kretschmer@fokus.fraunhofer.de>
To: Arend van Spriel <arend@broadcom.com>,
	Simon Wunderlich <sw@simonwunderlich.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [net-next v2 3/3] cfg80211: add MPLS and 802.21 classification
Date: Mon, 17 Feb 2014 17:34:34 +0000
Message-ID: <D53252F45158EF44B1DF124FDC9AF2A35AD9E12C@FEYNMAN.fokus.fraunhofer.de> (sfid-20140217_183614_443309_FB8DD91C)
References: <1392656174-14791-1-git-send-email-sw@simonwunderlich.de>
 <1392656174-14791-4-git-send-email-sw@simonwunderlich.de>
 <5302474B.6090609@broadcom.com>
In-Reply-To: <5302474B.6090609@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It seem eh->h_proto should be the same as skb->protocol, right? So why not
> add these case statements to the switch below?

Thought so, as well. But it seems that skb->protocol is not properly set when the packet originates from a packet socket.
And in our case we cannot set it to a fixed etherType in the bind() call since we use three different etherTypes on the same socket.

Cheers,

Mathias
 
> Regards,
> Arend
> 
> > +		case htons(ETH_P_MPLS_UC):
> > +		case htons(ETH_P_MPLS_MC):
> > +			/* MPLS */
> > +			mpls = skb_header_pointer(skb, sizeof(*eh),
> > +						  sizeof(*mpls),&mpls_tmp);
> > +			if (!mpls)
> > +				break;
> > +
> > +			return (ntohl(mpls->entry)&  MPLS_LS_TC_MASK)
> > +				>>  MPLS_LS_TC_SHIFT;
> > +		case htons(ETH_P_80221):
> > +			/* 802.21 is always network control traffic */
> > +			return 7;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +
> >   	switch (skb->protocol) {
> >   	case htons(ETH_P_IP):
> >   		dscp = ipv4_get_dsfield(ip_hdr(skb))&  0xfc;

