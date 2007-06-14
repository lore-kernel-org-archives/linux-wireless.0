Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45254 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbXFNJXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:23:08 -0400
Message-ID: <467108F6.3050508@warmcat.com>
Date: Thu, 14 Jun 2007 10:23:02 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH Try#12 2/3] cfg80211: Radiotap parser
References: <20070613093732.535166329@warmcat.com>	 <20070613093943.634743151@warmcat.com> <1181760467.29767.130.camel@johannes.berg>
In-Reply-To: <1181760467.29767.130.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi Andy,
> 
> Sorry, I really hate doing this, but I found yet another problem :/
> 
> Hi Andy,
> 
> Sorry, I really hate having comments again and again but never really
> thought about this earlier, the FCS removal thing you added made me
> think...
> 
> 
>> + * @max_length: total length we can parse into (eg, whole packet length)
> 
>> +	/* sanity check for allowed length and radiotap length field */
>> +	if (max_length < le16_to_cpu(radiotap_header->it_len))
>> +		return -EINVAL;
> 
>> +	iterator->max_length = le16_to_cpu(radiotap_header->it_len);
> 
> This is fine, at first sight, but if you let the caller modify the skb
> like mac80211 now does with stripping the FCS, the max length really
> needs to be passed to each invocation of
> ieee80211_radiotap_iterator_next in order to catch invalid skbs. Mind
> you, we wouldn't Oops since trimming just moves the skb tail pointer,
> but something that indicated a longer length and then just have a packet
> like

Hi Johannes -

No it sounds a real issue, don't feel bad!  I will look at it
thismorning and fold the changes from Michael into another try.

-Andy
