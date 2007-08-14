Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:50000 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935429AbXHNWqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 18:46:44 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1555488wxd
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2007 15:46:43 -0700 (PDT)
Message-ID: <1ba2fa240708141546g4de44ff1v94db00213a3187aa@mail.gmail.com>
Date: Wed, 15 Aug 2007 01:46:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1187002921.27916.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
	 <1186995104.27916.56.camel@johannes.berg>
	 <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
	 <1187002921.27916.77.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/13/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-08-13 at 13:46 +0300, Tomas Winkler wrote:
>
> >  I think it was a polite query I've made, don't see any reason to use
> > this language. If you precept it otherwise I apologize it wasn't my
> > intention.
>
> Apologies. I seriously don't understand that comment though, the patch
> didn't touch the management interface at all, in fact it renamed only a
> few variables and changed EAPOL frame receiving from using the
> management interface to the ethernet framed interface.
>
> > They have management meaning. So it was appropriate to route them
> > through management interface rather then from data interface.
>
> I'm not sure we understand each other. The only thing I changed with
> this patch and the corresponding kernel patch is that all data frames
> including those that are used for management purposes are now routed
> through the data interface. Why do you think that is wrong? Reordering
> your mail a bit, you also said
>
> > On the contrary what I'm saying that EAPOL packets are the only data
> > packets that should go up until handshake is done.
>
> which seems to agree with me. You can achieve the effect of letting
> *only* EAPOL packets through by setting the 802.1X protection parameter
> on the network interface via the private prism ioctl, hostapd doesn't
> seem to do that unless explicitly requested though.

> The actual technical reason for doing is that subsequent patches totally
> remove the management interface and on the monitor interface the EAPOL
> frames show up undecrypted.

Can you enlighten me and tell me why the monitor interface is
preferable over management interface? I've probably got busy and
missed the whole conversation.
 I'm not so familiar with monitor interface but isn't it to be
sniffing interface - everything goes up including data raw packets.
Thanks for keeping patience with me :)

What if management frames needs decryption? I think this is 802.11w
specs that defines that.

Thanks
Tomas

> johannes
>
>
