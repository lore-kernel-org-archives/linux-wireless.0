Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab1FVU7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:59:19 -0400
Received: by iyb12 with SMTP id 12so1000196iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 13:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308775948.29571.30.camel@jlt3.sipsolutions.net>
References: <1308775296-11627-1-git-send-email-arik@wizery.com> <1308775948.29571.30.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 22 Jun 2011 23:59:02 +0300
Message-ID: <BANLkTinR0fnO6f_Ei8q41rb1T3wLLR9tJQ@mail.gmail.com> (sfid-20110622_225928_169731_19009259)
Subject: Re: [PATCH] mac80211: fix rx->key NULL dereference during mic failure
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 23:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-06-22 at 23:41 +0300, Arik Nemtsov wrote:
>> Sometimes when reporting a MIC failure rx->key may be unset. This
>> code path is hit when receiving a packet meant for a multicast
>> address, and decryption is performed in HW.
>>
>> Fortunately, the failing key_idx is not used for anything up to
>> (and including) usermode, so we allow ourselves to drop it on the
>> way up when a key cannot be retrieved.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>
> It'd be nice to also update the docs for the cfg80211 function to
> document the -1 special case, but other than that:

Sure why not? :)
