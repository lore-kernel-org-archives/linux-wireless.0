Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39419 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1JTR4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 13:56:34 -0400
Received: by wyg36 with SMTP id 36so3155836wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 10:56:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319133104.17101.5.camel@jlt3.sipsolutions.net>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	<1319072606-28291-6-git-send-email-thomas@cozybit.com>
	<1319109412.3959.7.camel@jlt3.sipsolutions.net>
	<CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com>
	<1319133104.17101.5.camel@jlt3.sipsolutions.net>
Date: Thu, 20 Oct 2011 10:56:33 -0700
Message-ID: <CAG6hwVMmvu5jMQLeOWG2via0wqkHGs=nHSi_mKvgy9U2+m1FXA@mail.gmail.com> (sfid-20111020_195637_414761_7BB271D7)
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 10:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-10-20 at 10:41 -0700, Thomas Pedersen wrote:
>> On Thu, Oct 20, 2011 at 4:16 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2011-10-19 at 18:03 -0700, Thomas Pedersen wrote:
>> >> Include the WMM IE in mesh peering and beacon frames. This is needed
>> >> tell any potential peers what our WMM / EDCA parameters are.
>> >
>> > The goal seems fine but why bother building the WMM IE out of the actual
>> > TX queue configuration? Shouldn't it normally be the other way around?
>> > But I have no idea how QoS is supposed to work in a mesh...
>>
>> I'm not sure what you mean, this is the only way to get the WMM
>> parameters? Usually these are just set with ieee80211_set_wmm_defaul()
>> on bringing up the interface.
>
> Right, but
>  a) if you're using just the default, no need to derive from the default

The user might wish to customize the queue parameters though.

>  b) should they be changeable?

Why not?

Thomas
