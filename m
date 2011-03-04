Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49997 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab1CDSsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 13:48:21 -0500
Received: by vxi39 with SMTP id 39so2270667vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 10:48:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299238205.4348.1.camel@jlt3.sipsolutions.net>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
 <1299208307-9428-2-git-send-email-thomas@cozybit.com> <1299238205.4348.1.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 4 Mar 2011 10:48:00 -0800
Message-ID: <AANLkTikcszGwKe92rr6EmicRNrOF9hjpug0xrbxUgAfv@mail.gmail.com>
Subject: Re: [PATCH 1/7] mac80211: Support RSN information element on mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Fri, Mar 4, 2011 at 3:30 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
>
>> +++ b/include/net/cfg80211.h
>> @@ -656,6 +656,8 @@ struct mesh_config {
>>   * @path_metric: which metric to use
>>   * @vendor_ie: vendor information elements (optional)
>>   * @vendor_ie_len: length of vendor information elements
>> + * @rsn_ie: robust secure network information elements (for SAE)
>> + * @rsn_ie_len: length of rsn_ie
>
> Is this really useful over just putting it into the vendor IE we already
> have? We already have code to split IEs properly (see ieee80211_ie_split
> etc in mac80211), so maybe there's no reason to add more API?

Ah, I see.  No need for a new rsn_ie but just remove the "vendor_" prefix.
We'll do.

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
