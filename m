Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49335
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbXF0NfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 09:35:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Wed, 27 Jun 2007 15:33:56 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <1182934500.4769.8.camel@johannes.berg>
In-Reply-To: <1182934500.4769.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706271533.57189.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 June 2007 10:55:00 Johannes Berg wrote:
> On Mon, 2007-06-25 at 16:28 +0200, Michael Buesch wrote:
> 
> >  	case PRISM2_PARAM_PREAMBLE:
> > -		local->short_preamble = value;
> > +		if (value)
> > +			local_to_hw(local)->conf.flags |= IEEE80211_CONF_SHORT_PREAMBLE;
> > +		else
> > +			local_to_hw(local)->conf.flags &= ~IEEE80211_CONF_SHORT_PREAMBLE;
> > +		if (ieee80211_hw_config(local))
> > +			ret = -EINVAL;
> 
> any reason not to return the actual error code from hw_config here? Not
> that it'll be any different from -EINVAL I expect...
> 
> johannes
> 

Another thing, while we are at it.
How is locking for the conf structure actually done? How is it
made impossible to read the value of "flags" in another thread,
while we update it in a non-atomic way, here?

-- 
Greetings Michael.
