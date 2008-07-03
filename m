Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:53600 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYGCQpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:45:50 -0400
Received: by yx-out-2324.google.com with SMTP id 8so290146yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2008 09:45:47 -0700 (PDT)
Message-ID: <1ba2fa240807030945k1eb81286sd9560c067e0c12ff@mail.gmail.com> (sfid-20080703_184622_499157_AE1F12CC)
Date: Thu, 3 Jul 2008 19:45:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rfkill: ignore errors from rfkill_toggle_radio in rfkill_add_switch
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kionez <kionez@anche.no>
In-Reply-To: <200807031847.13748.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215101697-30576-1-git-send-email-hmh@hmh.eng.br>
	 <1215101697-30576-3-git-send-email-hmh@hmh.eng.br>
	 <1ba2fa240807030937q1fe14a9i53b2f192eeb3e7c3@mail.gmail.com>
	 <200807031847.13748.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 3, 2008 at 7:47 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Thursday 03 July 2008, Tomas Winkler wrote:
>> On Thu, Jul 3, 2008 at 7:14 PM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>> > rfkill_add_switch() calls rfkill_toggle_radio() to set the state of a
>> > recently registered rfkill class to the current global state [for that
>> > rfkill->type].
>> >
>> > The rfkill_toggle_radio() call is going to error out if the hardware is
>> > RFKILL_STATE_HARD_BLOCKED, and the global state is RFKILL_STATE_UNBLOCKED.
>> >
>> > That is a quite normal situation which I missed to account for.  As things
>> > stand, the error return from rfkill_toggle_radio ends up causing
>> > rfkill_register to bail out with an error (de-registering the new switch in
>> > the process), which is Not Nice.
>> >
>> > Change rfkill_add_switch() to not return errors because of a failed call to
>> > rfkill_toggle_radio().  We can go back to returning errors again (if that's
>> > indeed the right thing to do) if we define the exact error codes the
>> > rfkill->toggle_radio callbacks are to return in each situation, so that we
>> > can ignore the right ones only.
>> >
>> > Bug reported by "kionez <kionez@anche.no>".
>> >
>> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
>> > Cc: kionez <kionez@anche.no>
>> > ---
>> >  net/rfkill/rfkill.c |   10 ++++------
>> >  1 files changed, 4 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
>> > index aa7039d..7a560b7 100644
>> > --- a/net/rfkill/rfkill.c
>> > +++ b/net/rfkill/rfkill.c
>> > @@ -501,17 +501,15 @@ static struct class rfkill_class = {
>> >
>> >  static int rfkill_add_switch(struct rfkill *rfkill)
>> >  {
>> > -       int error;
>> > -
>> >        mutex_lock(&rfkill_mutex);
>> >
>> > -       error = rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
>> > -       if (!error)
>> > -               list_add_tail(&rfkill->node, &rfkill_list);
>> > +       rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
>> > +
>> > +       list_add_tail(&rfkill->node, &rfkill_list);
>> >
>> >        mutex_unlock(&rfkill_mutex);
>> >
>> > -       return error;
>> > +       return 0;
>> >  }
>>
>> So why this is not a void function
>
> Well as Henrique suggested we might add a correct return value later when
> we figured out which error codes should be returned. If the interface now goes
> to a void function, we need to fix all drivers only later to revert those changes
> again when it returns an int again.
> And this way drivers will at least keep it mind that the function might fail,
> perhaps not now, but perhaps later, when for example we are sane-checking
> the filled in fields of the rfkill structure, or do some other fancy things which
> might fail.

Fair enough
Tomas
