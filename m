Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34201 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1EFW2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:28:25 -0400
Received: by vxi39 with SMTP id 39so3874271vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 15:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304720248.3595.13.camel@jlt3.sipsolutions.net>
References: <1304719911-22636-1-git-send-email-javier@cozybit.com> <1304720248.3595.13.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 6 May 2011 15:28:03 -0700
Message-ID: <BANLkTinoSvA2uJg7bvNiAgkDz7wsr+uJug@mail.gmail.com> (sfid-20110507_002828_792280_DCC142BF)
Subject: Re: [PATCH] mac80211: Only process mesh PREPs with equal seq number
 if metric is better.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabrice Deyber <fabricedeyber@agilemesh.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 6, 2011 at 3:17 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-05-06 at 15:11 -0700, Javier Cardona wrote:
>> From: Fabrice Deyber <fabricedeyber@agilemesh.com>
>>
>> This fixes routing loops in PREP propagation and is in accordance with Draft
>> 11, Section: 11C.9.8.4.
>
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -391,7 +391,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
>>                           (mpath->flags & MESH_PATH_SN_VALID)) {
>>                               if (SN_GT(mpath->sn, orig_sn) ||
>>                                   (mpath->sn == orig_sn &&
>> -                                  action == MPATH_PREQ &&
>
> I don't understand how removing the action comparison maps to the patch
> description -- can you explain a bit more?

If the if condition is true, this PREQ or PREP will be ignored.  The
first part of the condition eliminates old sequence numbers, where the
metric is not checked.  The second part of the if condidion (||
(mpath->sn == ...) used to eliminate all the PREQs with equal seq
number and worse metric.  The patch modifies it to also eliminate
PREPs.

j


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
