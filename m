Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:10083 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751151AbYEGKjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 06:39:53 -0400
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: make rx radiotap header more flexible
Date: Wed, 7 May 2008 12:39:58 +0200
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <20080407042541.9026.59360.stgit@localhost> <200804292010.21367.bruno@thinktube.com> <1209564773.18659.14.camel@johannes.berg>
In-Reply-To: <1209564773.18659.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805071239.58383.bruno@thinktube.com> (sfid-20080507_123900_813074_C0311B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 April 2008 16:12:52 Johannes Berg wrote:
> > > Radiotap explicitly allows you to have a longer length than you need so
> > > maybe we should just make sure to align things?
> >
> > are you talking about the alignment of the radiotap header itself? no, i
> > just took care about the alignment requirements of the radiotap fields,
> > relative to the start of radiotap. but it would be easy to add some
> > additional length in ieee80211_rx_radiotap_len() and just leave that
> > empty at the end.
> >
> > i think i don't understand all alignment requirements though...
>
> Well all those stores there are usual 32/16-bit stores which will fault
> on some architectures. See Documentation/unaligned-access.txt. Adding
> some padding to make the radiotap header start at a mod8 boundary would
> help.

so if i assume that the skb already starts at such a mod8 boundary it should 
be enough to make the length of the radiotap header a multiple of 8, right? 
please check the patch which i will post shortly.

bruno
