Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59275 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaKJGto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 01:49:44 -0500
Message-ID: <1415602173.12617.5.camel@coelho.fi> (sfid-20141110_074948_157869_5526995B)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Mon, 10 Nov 2014 08:49:33 +0200
In-Reply-To: <545E1B97.9030104@broadcom.com>
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
	 <1415363870.12617.0.camel@coelho.fi>
	 <1415387721.1954.0.camel@sipsolutions.net>
	 <1D96301C-ADA3-4A41-9E1D-97D5A5C82B94@coelho.fi>
	 <545E1B97.9030104@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor
 namespace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,


On Sat, 2014-11-08 at 14:33 +0100, Arend van Spriel wrote:
> On 11/07/14 20:37, Luca Coelho wrote:
> > On November 7, 2014 9:15:21 PM EET, Johannes Berg<johannes@sipsolutions.net>  wrote:
> >> On Fri, 2014-11-07 at 14:37 +0200, Luca Coelho wrote:
> >>
> >>>> +#if 0
> >>>> +	struct ieee80211_vendor_radiotap *rtap;
> >>>> +
> >>>> +	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
> >>>> +	/*
> >>>> +	 * Don't enable this code by default as the OUI 00:00:00
> >>>> +	 * is registered to Xerox so we shouldn't use it here, it
> >>>> +	 * might find its way into pcap files.
> >>>> +	 * Note that this code requires the headroom in the SKB
> >>>> +	 * that was allocated earlier.
> >>>> +	 */
> >>
> >>> Is this #if 0'ed section here on purpose? If yes, maybe explain it in
> >>> the commit message?
> >>
> >> You're the second person to ask this, but come on ... really? :)
> >
> > Okay, I know I'm missing something. But i just hate #if 0s, especially when I don't easily understand the need for them.
> 
> You should read the comment block in the '#if 0' section. Maybe it helps :-p

Yeah, Johannes pointed out privately too.  I think I need glasses. :)

Anyway, I think it would be better to (at least) have the comment
*before* the if for increased visibility.

--
Cheers,
Luca.

