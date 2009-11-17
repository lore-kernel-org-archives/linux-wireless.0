Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:45200
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbZKQW23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:28:29 -0500
Message-ID: <4B032390.3080501@roinet.com>
Date: Tue, 17 Nov 2009 17:28:32 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de> 	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com> 	<4B02DFF4.1060509@roinet.com> <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com> 	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com> 	<4B03193E.2080304@roinet.com> <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com> 	<4B031B48.1090105@roinet.com> <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
In-Reply-To: <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Tue, Nov 17, 2009 at 1:53 PM, David Acker <dacker@roinet.com>
> wrote:
>> Luis R. Rodriguez wrote:
>>> On Tue, Nov 17, 2009 at 1:44 PM, David Acker <dacker@roinet.com>
>>> wrote:
>>>> It is a non-802.11s protocol that predates 802.11s development
>>>> by quite awhile.  It runs over WDS links.  In theory it could
>>>> run over anything that supports dynamic creation and
>>>> destruction of WDS links.
>>> So its a some sort of MadWifi-only hack?
>> Not at all.  The algorithm runs in user space
> 
> OK so not relevant.
True, but I was answering Michael's original question, "What are you
using MadWifi for?" I was trying to describe the system.  Sorry for the
confusion.

>> The problem with switching to ath5k would be the loss of
>> performance related features (compression, fast frames, turbo),
> 
> These are different than "mesh".

Yes, but it would be good if these features were supported over WDS
links (and on AP to STA links where both support the features).


>> and some required features (half/quarter rates are required for
>> some channels on some radios).
> 
> How does "mesh" relate to this?
It doesn't.  That is what the product I work on does.

> 
>> Also, I don't know if ath5k will work on products based on Atheros
>> WiSOCs like Ubiquiti's PicoStation and Bullet.
> 
> ath5k does not *yet* have SoC support but it may get it at later
> point.
That would be great.


> 
> So let me get this straight.
> 
> You have SoC Atheros solutions that use some userspace custom (not 
> 802.11s) solution that use fast frames, compression and turbo, oh and
>  half/quarter rates? WTF are you doing?

Lol, it isn't as crazy as it sounds.  I have meshing running on various
platforms. Some use miniPCI atheros based radios, some are SoC based.  I 
believe I misspoke when I said half/quarter rates.  It is better to say 
half width (10 MHz) or quarter width (5 MHz) channels.  There are 
several miniPCI based radios that require half or quarter width channels 
on some channels.  For example, the Ubiquiti XR7 requires quarter width 
channels on two of its four available channels.  The XR9 requires half 
width channels on two if its four available channels.  Sorry for any 
confusion I created.

> For backporting we have compat-wireless, it should allow you to use 
> even today's bleeding edge even on 2.6.25. It should be possible to 
> bring this down to 2.6.21 even but not many people are interested in 
> that it seems. Patches are welcomed though.
Thanks.  I am trying to decide which is more painful: porting a recent 
kernel to the hardware or porting compat-wireless down to 2.6.18.
