Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:48286 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3CDTUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 14:20:12 -0500
Received: by mail-la0-f48.google.com with SMTP id fq13so5262267lab.7
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 11:20:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362095777.8330.15.camel@jlt4.sipsolutions.net>
References: <1360797364-9430-1-git-send-email-johannes@sipsolutions.net>
 <1360797364-9430-2-git-send-email-johannes@sipsolutions.net>
 <CAB=NE6VonnZDQwat3PeCvnVJnuj-vKciK8WYCmbLzre+4zoLyw@mail.gmail.com> <1362095777.8330.15.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 4 Mar 2013 11:19:51 -0800
Message-ID: <CAB=NE6XWbOXUb8Ac8na-5iRRCaGLQgg5gWBKd7Hnuim7-rFAoA@mail.gmail.com> (sfid-20130304_202023_613979_B6178C3F)
Subject: Re: [PATCH 1/3] regulatory: allow VHT channels in world roaming
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, green@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2013 at 3:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2013-02-28 at 15:33 -0800, Luis R. Rodriguez wrote:
>
>> > For VHT, the wider bandwidths (up to 160 MHz) need
>> > to be allowed. Since world roaming only covers the
>> > case of connecting to an AP, it can be opened up
>> > there, we will rely on the AP to know the local
>> > regulations.
>
>> This seems reasonable to me but in your patch you only allow 80, not
>> 160, any reason for that?
>
> 160 doesn't fit here yet -- I think it should be enabled when/if those
> DFS channels are added, I don't see a reason they're missing there.

True. OK I checked internally and enabling VHT80 is reasonable, as for
the DFS stuff you mentioned, you are right as well, but that should be
done through a separate patch. The only thing to consider there is
scan time increases considerably but seems like a reasonable
compromise. I'm surprised no one has had issues before with this.

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
