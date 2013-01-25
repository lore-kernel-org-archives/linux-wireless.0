Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40375 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3AYKpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:45:50 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so464730lbb.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 02:45:48 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: Unable to get RTS/CTS working in rt2800
Date: Fri, 25 Jan 2013 11:45:45 +0100
Message-ID: <1537149.hyND0EvR7A@sylvesterjr.pats.ua.ac.be> (sfid-20130125_114555_193735_F6E8CCCC)
In-Reply-To: <CAGXE3d_fD9etSnMKFUb6YGz=4g85ACkvdgyPjusMJXus-nvFYg@mail.gmail.com>
References: <1731354.xZITKB59tC@sylvesterjr.pats.ua.ac.be> <CAGXE3d_fD9etSnMKFUb6YGz=4g85ACkvdgyPjusMJXus-nvFYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2013 09:42:31 Helmut Schaa wrote:
> On Thu, Jan 24, 2013 at 4:58 PM, Erwin Van de Velde
> 
> <erwin.vandevelde@gmail.com> wrote:
> > In a test setup with 802.11a/n a colleague and I tried enabling 
RTS/CTS.
> > The only thing we got however was a CTS to self. RTS threshold was 
1000B,
> > packet size 1400B.
> 
> Did you use 11n aggregation?

Yes, but afterwards we also tried it with 802.11a, same result.

> > We looked for other options but did not find anything
> > helpful, what else can we try to enable RTS/CTS?
> 
> Yup, there are several issues there:
> - The hw ignores RTS thresholds for AMPDUs AFAIK
> - HT protection always uses CTS-to-self (hardcoded in driver in
> rt2800_config_ht_opmode)
> 
> I don't think any other driver allows to configure if RTS-CTS or
> CTS-to-self should be used?
> You can easily enforce RTS-CTS for 11n transmissions by changing
> rt2800_config_ht_opmode.

Where do I configure that? Is it in the source code or is it a kernel 
module parameter?

Best regards,
Erwin

