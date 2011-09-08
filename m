Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49949 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1IHXdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 19:33:10 -0400
Received: by pzk37 with SMTP id 37so1809354pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 16:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315465312.3948.4.camel@jlt3.sipsolutions.net>
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
 <1315442994-304-2-git-send-email-javier@cozybit.com> <1315465312.3948.4.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 8 Sep 2011 09:17:27 -0700
Message-ID: <CAPjQAd9+QB2WpovrrLV3ArPRqv-tEY_HY3tKjYjvFcJZxM=LHg@mail.gmail.com> (sfid-20110909_013318_919363_9C17CB54)
Subject: Re: [PATCH v2 1/3] mac80211: Start implementing QoS support for mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 8, 2011 at 12:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-09-07 at 17:49 -0700, Javier Cardona wrote:
>
>> +     /* For mesh, the use of the QoS header is mandatory */
>> +     if (ieee80211_vif_is_mesh(&sdata->vif))
>> +             sta_flags |= WLAN_STA_WME;
>> +
>
> With patch 3, this piece seems unnecessary?

At that point we don't know who the next hop peer will so the previous
block (below) will not find an sta.  Also, we want the QoS header in
multicast frames.  So I thought this might be the least intrusive way.

>>>
        if (!is_multicast_ether_addr(hdr.addr1)) {
                rcu_read_lock();
                sta = sta_info_get(sdata, hdr.addr1);
                if (sta)
                        sta_flags = get_sta_flags(sta);
                rcu_read_unlock();
        }
>>>

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
