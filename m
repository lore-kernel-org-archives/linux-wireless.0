Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64813 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2JSQNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 12:13:09 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so885552iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2012 09:13:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1350654649.10678.3.camel@jlt4.sipsolutions.net>
References: <1349814468-6512-1-git-send-email-ashok@cozybit.com>
 <1349814468-6512-2-git-send-email-ashok@cozybit.com> <1350654649.10678.3.camel@jlt4.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 19 Oct 2012 09:12:48 -0700
Message-ID: <CAPjQAd9rcPavj67=7RO62XuxkeTm0bQMEkzekELsJ9dbDsubAw@mail.gmail.com> (sfid-20121019_181314_584764_01E651D8)
Subject: Re: [PATCH 2/2] [nl,cfg,mac]80211: Add nl80211 command to get mesh
 network statistics
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ashok Nagarajan <ashok@cozybit.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 19, 2012 at 6:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-10-09 at 13:27 -0700, Ashok Nagarajan wrote:
>
>>  /**
>> + * struct mesh_stats - 802.11s mesh statistics
>> + *
>> + * Used to provide statistical information about mesh
>> + *
>> + * @fwded_mcast: Mesh forwarded multicast frames
>> + * @fwded_unicast: Mesh forwarded unicast frames
>> + * @fwded_frames: Mesh total forwarded frames
>> + * @dropped_frames_ttl: Not transmitted since mesh_ttl == 0
>> + * @dropped_frames_no_route: Not transmitted, no route found
>> + * @dropped_frames_congestion: Not forwarded due to congestion
>> + */
>> +struct mesh_stats {
>> +     u32 fwded_mcast;
>
> Would it make sense to use u64 right away? A lot of netdev stats were at
> some point extended from u32 to u64 and that caused problems, maybe
> using u64 right away here would be good?

Definitely.

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
