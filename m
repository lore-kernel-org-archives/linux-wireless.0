Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36520 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdGAJHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Jul 2017 05:07:13 -0400
Date: Sat, 1 Jul 2017 10:06:55 +0100 (BST)
From: Sami Kerola <kerolasa@iki.fi>
To: Karel Zak <kzak@redhat.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org,
        util-linux <util-linux@vger.kernel.org>
Subject: Re: rfkill(8) move and improvements
In-Reply-To: <20170630074729.s3gknfobabgepk4h@ws.net.home>
Message-ID: <alpine.LNX.2.20.1707010956520.7939@imuri> (sfid-20170701_110721_650331_CBF9C089)
References: <alpine.LNX.2.20.1706251339500.25762@imuri> <1498745040.3141.6.camel@sipsolutions.net> <CAG27Bk0tKzqxkm6qqjGO6GJE7vxReRAQbvYGexjp+PBLo+RK_A@mail.gmail.com> <20170630074729.s3gknfobabgepk4h@ws.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Jun 2017, Karel Zak wrote:

> On Thu, Jun 29, 2017 at 10:23:12PM +0100, Sami Kerola wrote:
> > On 29 June 2017 at 15:04, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >> The otherday I ran powertop and it did rfkill to save battery, which
> > >> was particularly annoying because I had not installed rfkill(8)
> > >> package.
> > >> Fixing the immediate issue was relatively easy, but the ordeal made
> > >> me wonder if this tool could be moved to a package that is installed
> > >> by default to all systems, such as util-linux.
> > >
> > > [...]
> > >
> > >> What do you think, would the move and proposed updates be ok?
> > >
> > > I can't say I mind, and most of your proposed changes seem sensible,
> > > though I haven't reviewed them in enough detail to comment on them.
> > > Something that caught my eye here was comparing a string to _("all")
> > > which seems wrong, since that'd mean you'd have to type the translated
> > > version even on the command line? That seems really awkward (to put it
> > > charitably).
> > >
> > > However, at the same time, I have very little desire to get involved
> > > with util-linux as yet another project, so frankly I'd probably
> > > continue to "maintain" the current rfkill tool - which really hasn't
> > > changed in a very long time, and hope somebody else picks up
> > > maintenance of rfkill included in util-linux.
> > 
> > Hello Johannes,
> > 
> > Thank you for feedback. I removed the rfkill command strings from
> > translations, and gave hint to translators how to deal with them in
> > usage() output. Also in same go updates are rebased on top of
> > most recent upstream to get usage() --help and --version handling
> > done correctly.
> > 
> > What comes  to maintenance I am fairly optimistic util-linux is a
> > good home for the rfkill. Karel, what do you think?
> 
> I have no problem with it, if Johannes agree with this step. We have
> definitely manpower to maintain it.

Hello,

I did couple last minute changes to my remote branch, that should now be
ready for final review.

git://github.com/kerolasa/lelux-utiliteetit.git rfkill

The changes:

1. Add commit to make rfkill_event struct read size check to be back and
   forward compatible.
   https://github.com/kerolasa/lelux-utiliteetit/commit/fdb76db0d32fdd77bff49b6c2a7db77763b1c4e4

2. Refer this email thread in merge commit.
   https://github.com/kerolasa/lelux-utiliteetit/commit/0b6c2693debf1219cfbe39dcf70e208abc94c1af

3. Change 'yes' and 'no' in rfkill status output to 'blocked' and
   'unblocked' that are more associative with command strings. Here is a
   sample output:

   $ rfkill
   DEVICE            ID TYPE      SOFT      HARD
   ideapad_wlan      0  wlan      unblocked unblocked
   ideapad_bluetooth 1  bluetooth blocked   unblocked
   hci0              2  bluetooth blocked   unblocked
   phy0              3  wlan      unblocked unblocked

4. Mark in configure.ac rfkill is linux only utility.
   https://github.com/kerolasa/lelux-utiliteetit/commit/5f715abb96a4fa3699bcfdb35d029d7ae3a5ea07#diff-67e997bcfdac55191033d57a16d1408aR1596

5. Small wording change in --output manual page entry: s/list of all
   supported/list of available/. The later matches with --help output
   title, hopefully makes it easier to know what is being referred.

-- 
Sami Kerola
http://www.iki.fi/kerolasa/
