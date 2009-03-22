Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:20137 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZCVNBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 09:01:52 -0400
Received: by mu-out-0910.google.com with SMTP id g7so597516muf.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 06:01:49 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] Marvell CF8381
Date: Sun, 22 Mar 2009 14:01:58 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	hs4233@mail.mn-solutions.de
References: <200903220127.21836.marek.vasut@gmail.com> <200903220511.50229.marek.vasut@gmail.com> <1237709048.5100.682.camel@johannes.local>
In-Reply-To: <1237709048.5100.682.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903221401.58743.marek.vasut@gmail.com> (sfid-20090322_140154_943366_3BEED43D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 of March 2009 09:04:08 Johannes Berg wrote:
> On Sun, 2009-03-22 at 05:11 +0100, Marek Vasut wrote:
> > One more thing - I also had to apply the following patch in order to get
> > region code detected properly.
> >
> > le16_to_cpu(cmd.regioncode) = 0x3031 for me and Im definitelly not in
> > spain, but 0x30 (eu) looks reasonable.
> >
> > diff --git a/drivers/net/wireless/libertas/cmd.c
> > b/drivers/net/wireless/libertas/cmd.c
> > index 639dd02..ce32bc9 100644
> > --- a/drivers/net/wireless/libertas/cmd.c
> > +++ b/drivers/net/wireless/libertas/cmd.c
> > @@ -123,7 +123,7 @@ int lbs_update_hw_spec(struct lbs_private *priv)
> >          * only ever be 8-bit, even though the field size is 16-bit. 
> > Some firmware
> >          * returns non-zero high 8 bits here.
> >          */
> > -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> > +       priv->regioncode = (le16_to_cpu(cmd.regioncode) & 0xFF00) >> 8;
>
> I'd be more inclined to think that this was an endian bug? Does your
> machine happen to be big endian?

intel pxa270 (little endian). Btw. that macro le16_to_cpu should handle the 
endianness, shouldn't it ?

>
> johannes


