Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57635 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab3BTSWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:22:04 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so3797134bkc.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 10:22:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361348702.8629.0.camel@jlt4.sipsolutions.net>
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
 <1361197194.8555.17.camel@jlt4.sipsolutions.net> <CAGRGNgWLHTV2T9WFAGtB8Wz4=zNcrCUkHVFJX5Q=kdbFLTSKOQ@mail.gmail.com>
 <1361348702.8629.0.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 20 Feb 2013 10:21:34 -0800
Message-ID: <CAG6hwVNFffZ=gPi408WEAVd42yytxXe5zD_Y54G=hqbtwFcALw@mail.gmail.com> (sfid-20130220_192212_284100_1700300B)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 12:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Julian,
>
>> > What might be interesting is for drivers to somehow indicate they
>> > support it? But you wouldn't necessarily want drivers to "select MESH",
>> > so it'd probably have to be something like not allowing mesh to be
>> > turned on if no driver is turned on that has it? But that makes it
>> > complicated again, so it's all probably not worth it.
>>
>> IIRC, the standard way to do things like that is something like:
>>
>> config HAVE_MESH_DRIVER
>>     default n
>>
>> config RANDOM_DRIVER
>>     select HAVE_MESH_DRIVER
>>
>> config MESH
>>     default y if HAVE_MESH_DRIVER
>>
>> That way it's default on if drivers are selected which have mesh
>> support but still user selectable (either to disable or if out-of-tree
>> drivers want it).
>
> Ah, yes, I was thinking something like that but forgot about the
> "default ... if" syntax and gave up trying to reproduce it with "select"
> and "depends on" :-)
>
> That seems like the best of both worlds? Thomas?

Yes it's nice we can leave out mesh when not useful, will put this in
the PATCH. Do you think it will be alright if I go ahead and add the
'select' to all supported drivers in the same patch?

-- 
Thomas
