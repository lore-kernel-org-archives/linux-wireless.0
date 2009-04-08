Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39886 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbZDHSGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:06:50 -0400
Date: Wed, 8 Apr 2009 15:06:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090408180644.GH7802@khazad-dum.debian.net> (sfid-20090408_200654_260343_67D15C20)
References: <1238349195.24972.5.camel@johannes.local> <20090330211513.GF23749@khazad-dum.debian.net> <20090405145941.GA24963@khazad-dum.debian.net> <1239100579.22453.38.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239100579.22453.38.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 07 Apr 2009, Johannes Berg wrote:
> > As I said, ACPI platform drivers _do_ get errors when calling the ACPI
> > functions, or trying to do an EC transaction.  That applies to reads
> > just as well as it applies to writes.
> 
> And it also doesn't really matter. Yes, the current poll API isn't
> prepared to treat errors, but see below for a suggestion.

Ok.  The older one allowed for it, so that's where the divergence lies.

> > I.e. I can get AE_BUSY or something else while querying the thinkpad
> > firmware, and then, what should I do to return the data on the
> > query_state (and, for that matter, poll_hw_block) hooks?
> > 
> > Since there can be a clear error path from userspace to the rfkill
> > driver for reads and writes in many situations (e.g. on all sysfs
> > accesses to that driver's rfkill struct), this would be a good reason
> > to change the hooks to allow for that error path.
> 
> Totally bogus argument -- 99.9% of users will be using rfkill's input
> handler which has no way of reacting to errors, and neither does

Well, network manager would be using sysfs, and that's something that can
report errors properly to the user, if it gets them from the kernel.
While I am happy with rfkill-input, I can easily imagine someone wanting
to have all rfkill-related input events to go to network manager to get
some unified GUI treatment there, and a proper error path would be nice to
have in that case.

> userspace. And it's wrong too -- the sysfs files don't actually call
> into rfkill, they just report the current status.

Indeed, I just looked at the code.  I don't know why I had this wrong
recollection that I had added a proper error path there.

Well, I'd still prefer the API to have the error return, and if the core
doesn't have much use for it, it can consume it.  Fixing the core later to
propagate errors back to userspace if needed would be much easier than
fixing all users of the API.

> > Without that, I'd have, for example, to return false (unblocked) on
> > any errors from thinkpad-acpi, for safety reasons (a blocked radio is
> > never a hazard, but an unblocked one can be).  This is the kind of
> > stuff that a driver shouldn't need to decide by itself...
> 
> Eh? Your first half sentence is correct (up to "on any errors"), the
> rest is garbage. Yes, you'd have to return false so that the core
> assumes it can do something, but no, it has nothing to do with hazards.

Hmm?  Yes, it does.  The choice to return false (transmiter is not
blocked) when you don't know jack about its state is rooted to the fact
that you cannot tell the user (or the system) that a transmitter is
'secured' (i.e. blocked) when it is not, while the opposite is not that
bad.

The reason is the same reason why one _cannot_ implement the rfkill class
in hardware that doesn't give guarantees that the transmission will be
blocked from emmiting energy.

And all of this happens because a transmitter emitting energy at the wrong
place and time can cause problems.  Immediate examples are: undue
interference to sensitive equipment and sensor arrays, safety hazards
(unblock a laser while someone is cleaning the lens, unblock a microwave
radio when someone is in direct contact with the antenna), lightning, fire
and explosion hazard (emitting microwaves in highly explosive atmosphere
or in a highly 'charged' environment is not very safe), etc.  Yes, it _is_
far-fetched, but that's what is behind the regulations that brought rfkill
to life.

I know (now) that the old core was consuming the error status instead of
passing it through -- I wasn't aware of it anymore or I'd have tried to
fix it (and it _is_ probable that I was the one that wrecked it to begin
with).

If the 'return it is unblocked in case of doubt' also happens to be a
better choice for other reasons, that's good.

Anyway, please document that in case of errors one is to return "false" in
the kerneldoc if you won't add the error status to the API.

> > On a related note, it was not clear to me from looking only at
> > rfkill.txt and the linux/rfkill.h headers, how am I supposed to deal
> > with the software controlled component of the rfkill controller (the
> > hardware rfkill line is quite obvious, though).  I know there is a way,
> > but I haven't finished reading the core code to know which one, and the
> > docs didn't help, so they need an extra paragraph somewhere...
> 
> There's a function for that -- but no poll yet.

I don't really need a poll function for thinkpad-acpi (I get events), but
see below.

> I can be convinced to change the prototype of poll_hw_block to
> 
> 	void (*poll_hw_block)(void *data, bool *blocked);
> 
> so that drivers can say
> 	"*shrug*, I dunno right now, keep whatever I told you last".
> Returning an error, however, is completely pointless.

See my arguments above about why I like the error status in the hook API.
I think we will just have to agree to disagree on that.

And I don't personally care much about the constant poll hook (poll_*),
just about the opportunistic poll hook (get_status), and the hook to set
radio state.

> Bugs happen, and can be fixed; your defensive programming mantra just
> makes for messy code that has multiple ways of working "correctly". I
> quite obviously disagree -- if you can't read the status don't touch the
> variables.

I am fine with that, I know *I* do read the kerneldoc entries for
everything I use, and often I look at the code too, since one cannot trust
kerneldoc entries too much.

Still, I just ask that you document these requirements explicitly in the
kerneldoc entry for the hooks, as well as the expected behaviour the hooks
should take on error conditions ("return false", "don't touch the state",
whatever).

> > BTW: it is probably a good idea to document what the driver should do if
> > the core tries this on a radio that is hardware blocked, or if the
> > driver discovers the radio is hardware blocked the instant it tries to
> > software unblock it...
> 
> The first case doesn't happen... And it says so in the header file:
> 
>  * @set_block: turn the transmitter on (blocked == false) or off
>  *      (blocked == true) -- this is called only while the transmitter
>  *      is not hard-blocked. This must be assigned.
> 
> The second case _shouldn't_ happen (but can, due to race conditions);
> Then you just call set_hw_state before returning.

That is the sort of stuff that belongs in a doc somewhere for sure,
although one could infer it since the set_hw_state function makes it clear
that it can be called from anywhere, anytime... but it is not obvious.

> The third case, which you forgot, works the same as the second and needs
> no extra code either.

Ok.

> > It would be nice to have the core export a way to "force" both sw and hw
> > states at once, as well.  This lets the core optimize the issuing of
> > events and other internal changes and avoids bad mojo if the driver does
> > sw/hw force calls in the wrong order (which might cause a unblock-block
> > fast sequence, etc).
> > 
> > This would let drivers that have the worst case software blocking (it
> > exists, hw blocking also exists and is separate, and both sw and hw
> > blocking state could change behind the driver's back) work well, without
> > causing any extra complexity to the other drivers.
> 
> There may be some value in that, do you need polling for both though?
> Otherwise you'd need
> 	if (hw_blocked)
> 		set_hw_state(hw_blocked)
> 		set_sw_state(sw_blocked)
> 	else
> 		set_sw_state(sw_blocked)
> 		set_hw_state(hw_blocked)

Well, *I* have full events, so I can disable polling altoghether, and do
the above.

However, I liked the old rfkill core 'opportunistic polling' through the
get_state hook, which the new core could also do, because it GREATLY
reduced the time window where a state could be wrong because of some sort
of misdelivery of events (you can NEVER trust ACPI-based crap too much).

And to use the opportunistic pooling, I'd need to be able to return both
states, so I'd need the query_state hook to let me return both states at
once.

So, I'd really appreciate a "void get_state(void *data, bool *sw, bool
*hw)" hook (since you won't give me error status).

Or maybe even change the get_state and poll_hw hooks to a "void
(hook)(void *data)" thing, where the driver is expected to use
set_hw_state and friends to do the update instead of returning values.

As for the small code snippet above, I ask that you add a
set_hw_sw_state() function.  It would make my life as a driver writer
easier, it would be simpler to understand, and it would give the rfkill
core better optimization oportunities to avoid transient spurious
blocks/unblocks.

> If you really do need polling for the sw state as well as the hw state,
> I can be convinced to change poll_hw_block to
> 
> 	void (*poll_block)(void *data, bool *hw_blocked, bool *sw_blocked);

Do that to get_state() as well, and give me set_hw_sw_state(bool sw, bool
hw), and we have a deal.

Or change the poll and get_state hooks to void (*hook)(void *data), and
give us set_hw_state, set_sw_state and set_hw_sw_state functions to call.
I find this to be easier to use, but either choice would make me happy.

> You need much better reasons, however, to convince me to add any error
> return, I see absolutely no value in that. Neither rfkill's input
> handler nor the polling nor userspace has any means to react to errors.

Userspace can react to errors, by notifying the user.  rfkill-input can't
do anything right now, but we COULD (if the userspace people wanted) issue
uevents to get notifications sent to the user.  My point is that we can
certainly propagate the errors to someone who could do something about it
if we wanted, as long as we have the errors to propagate.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
