Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ABAC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5D1521479
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/li8mk8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5D1521479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbeKVCNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:13:13 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33645 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbeKVCNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 21:13:13 -0500
Received: by mail-qt1-f193.google.com with SMTP id l11so4268756qtp.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 07:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HGcHmFN06WC0z3MMo4/Yrvdrtj01eglUM0rXcIs3bTA=;
        b=k/li8mk8+5+UyRGnUKfLCzBpOcs7nsHuUAgtKO2Ej2mG2NvB9uYmNDmuLj3fO+iSiR
         9ZmN5dQMcCxkdPOapv2zEuKUpQMD3KzoO1nUHv1uTIXHjGx5nQF4GdS7NQ0eQrTFSH5n
         Jg15LXFZDHOgNz4DIh6cAMf1qd7TOowzKHsI7UGv8/MOOV48aH2MV6J4aG8tEHNXI2La
         DgXJVN/omgtVrl+1Q7qAkS7dPu+SFXtgoVpRrHn8QoHwFni/3VpeM+UlCgwPYvsVs5aw
         PCbgQz3iW3AJS9CaPQUPeBpHIsVAynrxBE2gVSCPkOeve3xl5XQ2knE66txMQ8F0meKZ
         TyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HGcHmFN06WC0z3MMo4/Yrvdrtj01eglUM0rXcIs3bTA=;
        b=GH4oUX4bImc/cGbpiZFCvr4ej8w8E29TK5mnpu4ajrz9nNDmdAh2LUAmt27XkP0yls
         t+nsTDfC+XT1yOV/oUcUfueb8ScwX3RqF9+ObPdlxnN92XwrDiBfwBEd4LWuXkxXJg6s
         9owb0ejxH7DJxhYixBKrVxdqcWf0vrODj0c1Rkc/yH+Un+CA0sOUKN/b49kaVqXvPE08
         8KdBFGOf03GLB8dEipcrf6DN8XCjAUH5HyiC1kp6ujO5hRD8V005QAiCBZ6+ja1YtERi
         JNz7o1QQ9m846WBX/jhk9atMIwiVKJTDpY+cpzaKhTkvaqUPfe436eLB1dwcXiEgvGA9
         G4EA==
X-Gm-Message-State: AGRZ1gL/TEwF2pVA28IrxTUvmxJbuZ3G9cM/qqXuaNQexX3DxNzzfgI1
        22XQft+xbpKTNWrjBI3dobuuWkrPdSQIJxTlr7I=
X-Google-Smtp-Source: AJdET5f07Feqqnek5vd1ToBtXE5jW+0F9zzf7qxTFkDWaClz/t9XpAz3TrW53nUmoTlZg6ynBx404vjj2PlbLbEKb7k=
X-Received: by 2002:ac8:326a:: with SMTP id y39mr6500962qta.175.1542814696134;
 Wed, 21 Nov 2018 07:38:16 -0800 (PST)
MIME-Version: 1.0
References: <1542814135.446217011@apps.rackspace.com>
In-Reply-To: <1542814135.446217011@apps.rackspace.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 21 Nov 2018 07:38:03 -0800
Message-ID: <CAA93jw5TDtrBDNKhyGhP6VimXavfja17uExYNZyb=x-fbHLDqw@mail.gmail.com>
Subject: Re: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add
 airtimeaccounting and scheduling to TXQs
To:     dpreed@deepplum.com
Cc:     David Lang <david@lang.hm>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is getting seriously offtrack for such a wide set of mailing
lists. Tis OK were it just make-wifi-fast, and
I'd encourage limiting the distribution in the future to just that.

that said, I'm tired of looking at patches this week, and this song's
going through my head. so... join in, and...

https://www.youtube.com/watch?v=3DW5_8U4j51lI

On Wed, Nov 21, 2018 at 7:28 AM David P. Reed <dpreed@deepplum.com> wrote:
>
> Really? Tires are Bluetooth? I don't think mine are, but now I want to fi=
gure out how that works. 1600Chips/sec is 600 microseconds per chip. They s=
pin at up to, say, radial rates that are a 100 revs/sec and thus take maybe=
 10 msec. to travel 30 cm. How much warble in a chip frequency is there?
>
> Ok, maybe they only need to work when the car is stopped.
>
> I would design a tire pressure system that sends, maybe, 10 bits per seco=
nd, at most. Or calibrate the sensor to produce 1 bit, and use the car meta=
l frame to carry the signal to the computer as a single bit. A very slowly =
varying sensor can be sensed without needing a battery, by using some passi=
ve, tuned circuit.

Well, please poke into it and get back to us. :)

> Bluetooth is way overkill, but cheap. I doubt it works well in the applic=
ation, though.

I honestly don't know a lot about how it works, I do know that many
tire systems DO use some form of radio, and it's a well described vuln
in several SF novels, in being able to track cars everywhere. It would
be good to *know* how bad the tire sensor problem actually was....

My specific desire to block bluetooth from outside of the car was that
I am perpetually seeing new devices to pair with, that I prefer my
conversation, no matter how theoretically secure it was to not escape,
and that there are all sorts of bluetoothy controls now that someone
could try to take over, and radio interference is a PITA. And my phone
perpetually tries to associate with things I'd rather it not associate
with.

So I could certainly see a cheap coating making the cockpit more
tempest rated being a win. "Available in 2020 from a Tesla dealer near
you!"

My car was built in 2003 and doesn't have any of this newfangled stuff.

> -----Original
> From: "David Lang" <david@lang.hm>
> Sent: Mon, Nov 19, 2018 at 9:12 pm
> To: "Dave Taht" <dave.taht@gmail.com>
> Cc: "Dave Taht" <dave.taht@gmail.com>, "Rajkumar Manoharan" <rmanohar@cod=
eaurora.org>, "Make-Wifi-fast" <make-wifi-fast@lists.bufferbloat.net>, "lin=
ux-wireless" <linux-wireless@vger.kernel.org>, "ath10k" <ath10k@lists.infra=
dead.org>, "Ben Greear" <greearb@candelatech.com>, "Felix Fietkau" <nbd@nbd=
.name>
> Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtimeaccount=
ing and scheduling to TXQs
>
> On Mon, 19 Nov 2018, Dave Taht wrote:
>
> >> I'm not sure if this was a fluke or not, but at Starbucks recently I s=
at outside,
> >> right next to their window, and could not scan their AP at all.  Previ=
ously, I sat
> >> inside, 3 feet away through the glass, and got great signal.  I wonder=
 what that was
> >> all about!  Maybe special tinting that blocks RF?  Or just dumb luck o=
f some sort.
> >
> > Ya know, I could definitely see a market for a material like that! I'd
> > like it for my car, so bluetooth wouldn't escape.
>
> That would break your tire pressure sensors (each car is rolling around
> broadcasting 4 unique bluetooth IDs, not hard to track)
>
> David Lang
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
