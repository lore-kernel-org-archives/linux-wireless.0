Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52503 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab3CWAKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 20:10:06 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so327040wiw.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 17:10:04 -0700 (PDT)
Date: Sat, 23 Mar 2013 01:09:50 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC V3 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130323000949.GA3495@gobelin> (sfid-20130323_011014_510186_0C7ACD01)
References: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com>
 <1363986499.8238.68.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363986499.8238.68.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 22, 2013 at 10:08:19PM +0100, Johannes Berg wrote:
> On Fri, 2013-03-22 at 16:48 +0100, Karl Beldan wrote:
> 
> > +		if (chandef.chan == local->_oper_chandef.chan)
> > +			chandef = local->_oper_chandef;
> > +		else {
> > +			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> > +			chandef.center_freq1 = chandef.chan->center_freq;
> > +		}
> 
> I'll agree with checkpatch that you should probably put braces against
> both arms of the if :)
> 
> > -	if (chan != local->_oper_channel ||
> > -	    channel_type != local->_oper_channel_type)
> > +		chandef.chan = local->tmp_channel;
> > +		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> > +		chandef.center_freq1 = chandef.chan->center_freq;
> > +	} else
> > +		chandef = local->_oper_chandef;
> 
> same here I guess
> 
> > +	/*
> > +	 * FIXME: Here we are downgrading to NL80211_CHAN_WIDTH_20_NOHT
> > +	 * and don't adjust our ht/vht settings
> > +	 * This is wrong - we should behave according to the CSA params
> > +	 */
> 
> I can live with this in this patch. I know we need to fix it, but I
> don't want to do it in this patch nor do I really want to require it for
> this patch. If you feel it's a requirement for this feel free to pick up
> my other patches, but then I'd prefer you did it in a separate patch.
> 
Then I'll remove the FIXME

> > - out:
> > +out:
> 
> that seems a little unnecessary :)
> 
> >  #define CHANDEF_ASSIGN(c)							\
> > -			__entry->chan_width = (c)->width;			\
> > -			__entry->center_freq1 = (c)->center_freq1;		\
> > +			__entry->chan_width = (c)->width;				\
> > +			__entry->center_freq1 = (c)->center_freq1;			\
> 
> hmm, why did these lines change?
> 

To align the ending backslashes with that of the control_freq line in :
(your quote is missing the line that induced the shifts)

 #define CHANDEF_ASSIGN(c)                                                      \
-                       __entry->control_freq = (c)->chan->center_freq;         \
-                       __entry->chan_width = (c)->width;                       \
-                       __entry->center_freq1 = (c)->center_freq1;              \
+                       __entry->control_freq = (c)->chan ? (c)->chan->center_freq : 0; \
+                       __entry->chan_width = (c)->width;                               \
+                       __entry->center_freq1 = (c)->center_freq1;                      \

Now, looking at this it seems I forgot to align the CHANDEF_ASSIGN
ending backslash .. and to be perfectly in line I'd add that it asks to
shift every CHANDEF_* ending backslashes which, coincidentally, would
get aligned with the VIF_* ending backslashes.

 
Karl
