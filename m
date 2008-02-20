Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:65393 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbYBTXL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 18:11:59 -0500
Received: by fk-out-0910.google.com with SMTP id z23so3158469fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 15:11:57 -0800 (PST)
Message-ID: <247d6d340802201511u59b56ac8g128b28147fe92176@mail.gmail.com> (sfid-20080220_231207_034178_8AD13707)
Date: Thu, 21 Feb 2008 01:11:56 +0200
From: "Guy Cohen" <guy.cohen@intel.com>
To: "Sam Leffler" <sam@errno.com>
Subject: Re: implementing APSD?
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Michael Renzmann" <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"bruno randolf" <br1@einfach.org>
In-Reply-To: <47BC76FC.7070109@errno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203521087.17534.74.camel@johannes.berg>
	 <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com>
	 <47BC76FC.7070109@errno.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/20/08, Sam Leffler <sam@errno.com> wrote:
> Tomas Winkler wrote:
> > On Feb 20, 2008 5:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> >> Hi,
> >>
> >> I've long thought about implementing APSD but it seems to require
> >> setting the "more data" bit in an ACK frame and various other things.
> >> Ron, I think you're the QoS expert, is that really how APSD works? If
> >> so, does iwl firmware implement that?
> >>
> >
> > We have uAPSD implementation, mainly AP part, yet again it for  older
> > mac. It will take a bit time to merge it in
> > It's a mandatory feature for HT AP.
> >
>
> Really?  Can you point where that's called out in the spec?

You can not get WFA 11n certification without getting first WMM-uAPSD
certification.

4965AGN uCode image supports uAPSD in client mode (and certified under
Windows). uAPSD in AP mode is under developement currently.

> >
> >> Also, does Atheros hardware implement that, and how? It doesn't look
> >> like Broadcom firmware implements it, and I don't really understand how
> >> one could implement it without many hardware queues, since it seems
> >> timing critical to send out the frames to the station that is using
> >> APSD.
> >>
> >>
> > Don't believe it's possible to that without HW support.
> >
>
> Sorry, this is incorrect; you can do UAPSD w/o any special h/w support.
>
>    Sam

I think you may do uAPSD client mode w/o special HW/FW support (though
it won't be optimized), but definitelly not AP mode - you need some RT
capabilites for tracking the client state (wake/sleep/doze) and stop
sending frames to a client that entered a sleep state, need to avoid
out-of-order transmission when rescheduling frames that were dropped
because a client entered sleep/doze state, Service Period control,
etc.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
