Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61356 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2F0Kkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 06:40:32 -0400
Received: by obbuo13 with SMTP id uo13so1292903obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 03:40:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340788995.11012.4.camel@jlt3.sipsolutions.net>
References: <1340621899-15002-1-git-send-email-eliad@wizery.com>
	<1340788995.11012.4.camel@jlt3.sipsolutions.net>
Date: Wed, 27 Jun 2012 13:40:31 +0300
Message-ID: <CAB3XZEeXBROkOKqipgPmb0dxOvhd2AsPbiYv+eYQDp_LCcXxmQ@mail.gmail.com> (sfid-20120627_124036_148991_6C8F1BC9)
Subject: Re: [PATCH] mac80211: flush queues before deauth/disassoc
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 12:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-25 at 13:58 +0300, Eliad Peller wrote:
>> On deauth/disassoc we tear down all BA sessions. These
>> DELBA packets are sent on the appropriate TID, while
>> deauth/disassoc is always sent on VO. This sometimes
>> ends with the DELBA being sent after the deauth was
>> already sent.
>>
>> Fix it by flushing all the pending frames before
>> sending deauth/disassoc (in ieee80211_send_deauth_disassoc).
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>> i think flushing in ieee80211_send_deauth_disassoc is the
>> easiest thing to do here, as it handles all the (future) cases.
>> however, i don't care moving the flush to a higher function
>> if someone prefers it.
>
> I thought about this a bit ... Currently we have two calls to this
> function, one from the actual set_disassoc() and one from
> ieee80211_mgd_deauth(). In the latter case, we don't actually need the
> flush I think, and in set_disassoc() we already have a flush call, so I
> think it makes more sense there?
>
sure. i'll change it.

Eliad.
