Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52371 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbYG3EHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:07:17 -0400
Date: Wed, 30 Jul 2008 01:07:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/6] rfkill: query EV_SW states when rfkill-input
	(re)?connects to a input device
Message-ID: <20080730040711.GB19961@khazad-dum.debian.net> (sfid-20080730_060721_378315_94AA9DC8)
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-6-git-send-email-hmh@hmh.eng.br> <20080729205315.GB10188@tuxdriver.com> <20080730013024.GB22649@anvil.corenet.prv> <20080730033952.GA19961@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080730033952.GA19961@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry!

On Wed, 30 Jul 2008, Henrique de Moraes Holschuh wrote:

> On Tue, 29 Jul 2008, Dmitry Torokhov wrote:
> > On Tue, Jul 29, 2008 at 04:53:15PM -0400, John W. Linville wrote:
> > > On Mon, Jul 21, 2008 at 09:18:21PM -0300, Henrique de Moraes Holschuh wrote:
> > > > Every time a new input device that is capable of one of the rfkill EV_SW events
> > > > (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must check the
> > > > states of the input EV_SW switches and take action.  Otherwise, we will ignore
> > > > the initial switch state.
> > > > 
> > > > We also need to re-check the states of the EV_SW switches after a device that
> > > > was under an exclusive grab is released back to us, since we got no input
> > > > events from that device while it was grabbed.
> > > > 
> > > > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > > > Cc: Dmitry Torokhov <dtor@mail.ru>
> > > 
> > >   CC [M]  net/rfkill/rfkill-input.o
> > > net/rfkill/rfkill-input.c: In function ???rfkill_start???:
> > > net/rfkill/rfkill-input.c:201: warning: passing argument 2 of ???constant_test_bit??? from incompatible pointer type
> > > net/rfkill/rfkill-input.c:201: warning: passing argument 2 of ???variable_test_bit??? from incompatible pointer type
> > > net/rfkill/rfkill-input.c:202: warning: passing argument 2 of ???constant_test_bit??? from incompatible pointer type
> > > net/rfkill/rfkill-input.c:202: warning: passing argument 2 of ???variable_test_bit??? from incompatible pointer type
> > > net/rfkill/rfkill-input.c:203: warning: passing argument 2 of ???constant_test_bit??? from incompatible pointer type
> > > net/rfkill/rfkill-input.c:203: warning: passing argument 2 of ???variable_test_bit??? from incompatible pointer type
> > > 
> > > Don't you need an index for those evbit, swbit, and sw arrays?
> > 
> > No, we just need to drop the &:
> > 
> > diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> > index 827f178..e5b6955 100644
> > --- a/net/rfkill/rfkill-input.c
> > +++ b/net/rfkill/rfkill-input.c
> > @@ -198,10 +198,10 @@ static void rfkill_start(struct input_handle *handle)
> >  	 * just fine (which event_lock will also avoid). */
> >  	spin_lock_irq(&handle->dev->event_lock);
> >  
> > -	if (test_bit(EV_SW, &handle->dev->evbit)) {
> > -		if (test_bit(SW_RFKILL_ALL, &handle->dev->swbit))
> > +	if (test_bit(EV_SW, handle->dev->evbit)) {
> [...]
> 
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> John, do you want me to fix the patch and resend it, instead of Dmitry's
> incremental fix?
> 
> Anyway, gcc 4.3 and 4.2 don't complain about the &array here, and
> unfortunately my C-spec-fu is not strong enough to know what is wrong with
> "&array" instead of just "array", or "&array[0]".  They are all equivalent
> to gcc 4.2 and 4.3.

Oh, I see. type of &swbit is "pointer to unsigned int[]", while swbit (and
&swbit[0]) are "pointer to unsigned int".  Bleh. Never mind that the correct
type to be using for *_bit's target would be "pointer to unsigned int[]",
that would be a pain to use most of the time...

Sometimes, I really hate C.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
