Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:19233 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940400AbXHMKqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 06:46:22 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1169600wxd
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2007 03:46:20 -0700 (PDT)
Message-ID: <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
Date: Mon, 13 Aug 2007 13:46:18 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1186995104.27916.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
	 <1186995104.27916.56.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/13/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2007-08-12 at 13:58 +0300, Tomas Winkler wrote:
>
> > Isn't the removal of management interface a bit premature?  I didn't
> > see any proposal how to move management packets to the application
> > level?  If not I would prefer eapol packets be treated on management
> > path. No data should be received on data interface till security
> > negotiation is done.
>
> Have you read the patch or are you just ranting? I'm guessing the
> latter? The patch didn't remove the management interface at all.
>
 I think it was a polite query I've made, don't see any reason to use
this language. If you precept it otherwise I apologize it wasn't my
intention.

> Besides, what point is there in not allowing EAPOL packets through?

On the contrary what I'm saying that EAPOL packets are the only data
packets that should go up until handshake is done.
They

> are fundamentally data packets so they belong onto the AP mode ethernet
They have management meaning. So it was appropriate to route them
through management interface rather then from data interface.
> framed device, and they won't be interpreted by any other application.
> You'll have to come up with better reasons than "I prefer" blabla.
>
Tomas
> johannes
>
>
