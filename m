Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:23141 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbYFIQZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:25:34 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2168358wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 09:25:34 -0700 (PDT)
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212997025.698.51.camel@johannes.berg>
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997025.698.51.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 09:25:32 -0700
Message-Id: <1213028732.5974.13.camel@brick> (sfid-20080609_182540_759275_E0CC81A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 09:37 +0200, Johannes Berg wrote:
> > +static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr,
> 
> I think this is wrong, the header len will probably at some point
> include more things like HT headers where present or similar, so
> subtracting 2 from the header len is going to be wrong as soon as that
> happens because the QoS control will stay first. I think this should do
> the relevant calculation itself, ie. check for A4.

OK.

> 
> > +static inline int ieee80211_has_protected(__le16 fc)
> 
> > +static inline int ieee80211_has_morefrags(__le16 fc)
> 
> > +static inline int ieee80211_has_tods(__le16 fc)
> 
> > +static inline int ieee80211_has_fromds(__le16 fc)
> 
> > +static inline int ieee80211_has_a4(__le16 fc)
> 
> > +static inline int ieee80211_is_mgmt(__le16 fc)
> 
> > +static inline int ieee80211_is_ctl(__le16 fc)
> 
> > +static inline int ieee80211_is_data(__le16 fc)
> 
> > +static inline int ieee80211_data_has_qos(__le16 fc)
> 
> Can you add kernel-doc comments for these?

OK.

Harvey

