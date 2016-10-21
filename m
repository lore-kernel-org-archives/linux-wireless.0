Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33226 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932359AbcJUNRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 09:17:05 -0400
Message-ID: <1477055820.4068.48.camel@sipsolutions.net> (sfid-20161021_151708_371143_708628EF)
Subject: Re: [PATCH 1/2] mac80211: fix some sphinx warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@intel.com>, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Date: Fri, 21 Oct 2016 15:17:00 +0200
In-Reply-To: <87h985q1y6.fsf@intel.com>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
         <1477054872.4068.43.camel@sipsolutions.net> <87h985q1y6.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 16:14 +0300, Jani Nikula wrote:
> On Fri, 21 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > On Fri, 2016-10-21 at 15:57 +0300, Jani Nikula wrote:
> > > 
> > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > ---
> > >  include/net/mac80211.h | 21 +++++++++++++--------
> > >  1 file changed, 13 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > > index a810dfcb83c2..e2dba93e374f 100644
> > > --- a/include/net/mac80211.h
> > > +++ b/include/net/mac80211.h
> > > @@ -811,14 +811,18 @@ enum mac80211_rate_control_flags {
> > >   * in the control information, and it will be filled by the rate
> > >   * control algorithm according to what should be sent. For
> > > example,
> > >   * if this array contains, in the format { <idx>, <count> } the
> > > - * information
> > > + * information::
> > > 
> > [...]
> > 
> > interesting, are these not enabled by default?

> rst wants indented blocks to be separated by blank lines from the
> preceding and following blocks. For that you could just add the blank
> lines, and it'll work.
> 
> I presumed this was nicer as preformatted/monospaced text, and for
> that you'll need the "::". Up to you to have that or not.

Well, I meant the warnings :)

But yeah, this is better as preformatted text. It never came out that
way with docbook either, I think, but now we can fix that.

> > I guess I'll pick up these patches, even if they probably make
> > things
> > worse in my tree, since there it's still using docbook. But once we
> > merge everything it should be good then.
> 
> Oh, it's built as reStructuredText in Linus' tree. Again, up to you.

Right. No worries. I just haven't gotten my own change back from
Linus's tree into mine, but it only means that generating the doc from
mac80211-next or net-next might be weird, which isn't a problem.

johannes
