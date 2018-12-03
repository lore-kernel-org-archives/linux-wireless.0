Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135C6C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 21:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEF68206B7
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 21:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=pobox.com header.i=@pobox.com header.b="YxeEI7hh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEF68206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=pobox.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbeLCVqg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 16:46:36 -0500
Received: from pb-smtp1.pobox.com ([64.147.108.70]:65200 "EHLO
        pb-smtp1.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbeLCVqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 16:46:36 -0500
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 6719C109632;
        Mon,  3 Dec 2018 16:46:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=YUW1G36vFeag
        04bhM8lrmJmmccI=; b=YxeEI7hhwu7C/LpoHzG5wFc17tQSbsj/+VdcR/opWlNy
        7wtz9rlfUeKMfK7L0Pu56HG9YWXtZBzLybsRxlTxCngbiR1PTBqj269qMP/oc5QY
        GftL273WdRvq90wqmd32ETX+IsFyztFgwldxAcz514rcqRqFP9HmKiSaso2Si1o=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=JzHdAb
        XjY7orm6gyahd2DBZaUirK0CWyaTOMmga6OrE1Jq7DCu+ywo0W71/JOuZoqnzPkb
        mdItrMNEykMiE+VFF1kJmGlPuhiWhXpOIHRpcBQNGb2IPGOXtAyvXLNCKQwS2bWj
        dVA6IMo2x1xHfiQRbZO8yW6QYXis6xaJMvf2c=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 6047E109631;
        Mon,  3 Dec 2018 16:46:33 -0500 (EST)
Received: from [10.69.183.138] (unknown [108.91.94.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id A5700109630;
        Mon,  3 Dec 2018 16:46:32 -0500 (EST)
Subject: Re: rt2800 tx frame dropping issue.
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com>
 <3e8017792ea5eaa63f7795d9d37e7dcf85cdc612.camel@sipsolutions.net>
 <20181126093826.GB2047@redhat.com>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <b23f23bb-c543-bf9c-2827-618841a9b708@pobox.com>
Date:   Mon, 3 Dec 2018 15:44:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181126093826.GB2047@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: E657D2A0-F744-11E8-BB30-063AD72159A7-06139138!pb-smtp1.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/26/18 3:38 AM, Stanislaw Gruszka wrote:
> On Fri, Nov 23, 2018 at 08:45:54PM +0100, Johannes Berg wrote:
>> On Tue, 2018-11-20 at 15:20 -0600, Daniel Santos wrote:
>>
>>> I believe I have the answer as to why we're getting frames after we s=
top
>>> the queue.  I had a little chat about this in #kernelnewbies and some
>>> other devs believe it is intentional.
>>>
>>> There is a race in ieee80211_tx_frags (net/mac80211/tx.c) between
>>> releasing local->queue_stop_reason_lock and calling the driver's tx
>>> until we lock queue->tx_lock in rt2x00queue_write_tx_frame -- in betw=
een
>>> these two points the thread can be preempted.  So while we stop the
>>> queue in one thread, there can be 20 other threads in between that ha=
ve
>>> already checked that the queue was running and have a frame buffer
>>> sitting on their stacks.
>> Not 20, only 1 per netdev queue. I suspect that means just 1 per
>> hardware queue, but I don't know how rt2x00 maps netdev queues to
>> hardware queues. If you have lots of netdevs, that might actually be 2=
0,
>> but I suspect that's not what's going on here.
>>
>>>   I think it could be fixed with the below
>>> patch, but I'm being told that it doesn't need it and that the driver
>>> should just *quietly* drop the frame:
>> [snip patch]
>>
>>> Could anybody illuminate for me why this isn't done?  I know that the=
re
>>> has to be a point where we realize there are too many items in the qu=
eue
>>> and we can't keep up, but this would seem to be a terrible way to do
>>> that.  Is it one of those things where it isn't worth the performance
>>> degradation?  Any insights would be most appreciated!! :)
>> There's just not much point, and doing the locking here will mean it's
>> across _all_ queues, whereas if you have multiple hardware queues you
>> wouldn't really need it.
>>
>> Note that with internal TXQs with fq/codel support etc. we actually ha=
ve
>> the fq->lock and it's global, and it turns out that's still a better
>> deal than actually doing parallel TX. So this may not matter so much.
>>
>> In any case, while this might solve the problem for the specific case
>> you're thinking about, as soon as you have something else starting or
>> stopping queues from outside the TX path it still wouldn't actually
>> help.
>>
>> By the way, one thing that can likely exacerbate the problem is
>> fragmentation, once you have that you're more likely to trigger lots o=
f
>> frames in close succession.
>>
>> What I would suggest doing in the driver is actually stop the queues
>> once a *threshold* is reached, rather than being full. Say if you have
>> 128 entries in the HW queue, you can stop once you reach 120 (you
>> probably don't really need the other 8 places). If you get a 121st
>> frame, then you can still put it on the queue (until you filled 128),
>> but you can also stop the queue again (stopping queues is idempotent).
> That what rt2x00 does, but we have 64 entries on tx queues and
> because of that threshold is small. In:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D82751
>
> I proposed increase of queue size to 256 and hence make threshold
> bigger. However I was concerned about bufferbloat and requested
> testing from users how this affect latency. Never get testing=20
> results :-(
>
> Thanks
> Stanislaw
>
Hello Stanislaw,

I almost managed to get that patch in a build to send to somebody who
can reproduce the error in abundance, but they have 15 different people
hammer the router to do it and we ended up sending them a few other
experimental builds instead.

I'm still learning this driver, but I don't see where it creates a
struct net_device -- was that something that came out after the driver
was originally written? (And maybe gets implicitly created somewhere
else?)=C2=A0 iiuc, the best way to do this is by setting tx_queue_len whi=
le
the interface is down (via "ip link") and then allocating the queue when
it's brought up.

Unless you know of a problem with this approach, I'm planning on making
a patch just for that.=C2=A0 It will then be easier to tune for an end us=
er's
particular application.=C2=A0 For instance, if there is a small number of
uses who just use a very large amount of bandwidth then buffer bloat
could become a problem if it's too high.=C2=A0 But for a larger number of
users I don't think the buffer bloat probably will matter as much as
lost performance from dropping frames and needing to re-request many
lost packets at the TCP layer.=C2=A0 This would also result in more uplin=
k
bandwidth being consumed.

BTW, I guess we need that struct net_device object in order to increment
tx_dropped properly as well.

Thanks,
Daniel
