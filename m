Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62212 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1H3VjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 17:39:17 -0400
Received: by pzk37 with SMTP id 37so142704pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 14:39:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314729813.4011.43.camel@jlt3.sipsolutions.net>
References: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
 <1314728954-22646-1-git-send-email-javier@cozybit.com> <1314729813.4011.43.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 30 Aug 2011 14:38:57 -0700
Message-ID: <CAPjQAd9Fyu-MQSvi+aa4VwwWBTo_Brf=jCvAEnLdQZaJvjvu=Q@mail.gmail.com> (sfid-20110830_233922_783748_8D9A5E32)
Subject: Re: [PATCH] mac80211: Defer tranmission of mesh path errors
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 11:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-08-30 at 11:29 -0700, Javier Cardona wrote:
>> Under failure conditions, the mesh stack sends PERR messages to the
>> previous sender of the failed frame.  This happens in the tx feedback
>> path, in which the transmission queue lock may be taken.  Avoid a
>> deadlock by sending the path error via the pending queue.
>>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> ---
>>  net/mac80211/mesh_hwmp.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index fd4f76a..f760679 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -209,6 +209,10 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
>>   * @target_sn: SN of the broken destination
>>   * @target_rcode: reason code for this PERR
>>   * @ra: node this frame is addressed to
>> + *
>> + * Note: This function may be called from the tx feedback path, possibly with
>> + * the transmission queue lock taken.  To avoid a deadlock we don't transmit
>> + * the frame directly but add it to the pending queue instead.
>
> I'd change that to say "with driver locks taken that the driver also
> acquires in the TX path" or something like that maybe?

OK

> But that's not a big thing. Have you tested it? I'm wondering if because
> we take a lock here we might run into lock dependencies issues (lockdep
> would say) but I don't think so because stop_queue etc. all take the
> same lock from an arbitrary driver context already.

We don't have a test specific for that particular perr.  Other tests
run fine and lockdep does not complain.
I can resubmit the patch with the clearer comment once we've run our
whole test suite if that gives you peace of mind.

Javier

> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>
> johannes
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
