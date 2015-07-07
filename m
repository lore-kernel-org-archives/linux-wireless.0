Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34093 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbGGLJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 07:09:21 -0400
Received: by wgfr2 with SMTP id r2so9700549wgf.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 04:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559AD13B.7030105@thinktube.com>
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
	<55965CF8.20208@thinktube.com>
	<CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com>
	<CAFSTUk6u6rNF1njVBMFT4VAKPZ0Y6BvHB3mJEu7H7oM3tma5tQ@mail.gmail.com>
	<559AD13B.7030105@thinktube.com>
Date: Tue, 7 Jul 2015 12:09:19 +0100
Message-ID: <CAFSTUk7T_kA0OxuUApQp0Nj0kqv0pS945Y+KssokYa2Ow2F+-g@mail.gmail.com> (sfid-20150707_130925_334211_7B77912D)
Subject: Re: mesh support on rtl8192cu
From: Richard Palethorpe <richard@lm-technologies.com>
To: Bruno Randolf <br1@thinktube.com>
Cc: Taehee Yoo <ap420073@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 6, 2015 at 8:04 PM, Bruno Randolf <br1@thinktube.com> wrote:
>
> On 07/06/2015 11:46 AM, Richard Palethorpe wrote:
> > Bruno, that surprises me somewhat because I have got IBSS mode to work
> > on kernel 4.0+. Are you using a slightly older kernel?
>
> I'm using kernel 3.18 with wireless drivers from backports in OpenWRT
> CC, so it should be pretty recent...
>
> I wonder to what level did you verify the IBSS operation?
>
> I did get it to basically work as well, sometimes it works well, but
> sometimes I get a packet loss of about 15-20% and outages of
> connectivity for a while. This happens not always immediately, but
> reproducibly after some time. Try pinging for an hour or so...?
>
> I traced it down to ARP replies being apparently "sent" on the device
> (tcpdump shows it locally) but they don't make it onto the "air"...
>
> If you or anyone else can confirm ad-hoc mode really works, on some
> version of the driver, I'll start to investigate more.
>
> bruno
>

I don't recall how long I tested it for before, but I have tested it
again and now it is settling down to about 15-20% packet loss. arping
has a lower packet loss of around 6%. So as you say, that probably
means the handling of at least ARP frames/packets is broken in some
way.
