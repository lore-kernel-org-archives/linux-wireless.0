Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:58115 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYFIQb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:31:29 -0400
Received: by yx-out-2324.google.com with SMTP id 31so192757yxl.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 09:31:28 -0700 (PDT)
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212997265.698.55.camel@johannes.berg>
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 09:31:26 -0700
Message-Id: <1213029086.5974.21.camel@brick> (sfid-20080609_183132_187578_74DDDAD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 09:41 +0200, Johannes Berg wrote:
> > +static inline int ieee80211_data_has_qos(__le16 fc)
> > +{
> > +	/*
> > +	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
> > +	 * to check the one bit
> > +	 */
> > +	return (fc &
> > +	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) ==
> > +	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
> > +}
> 
> Shouldn't that rather be _is_qos_data?
> 

I don't think so....I was trying to keep it so _is_ meant an exact comparison and
_has_ was checking the presence of particular bits.

As this helper only checks for the one bit being set, I chose _has_.

Harvey

