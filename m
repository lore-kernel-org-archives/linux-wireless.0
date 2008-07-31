Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:55871 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYGaTQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 15:16:23 -0400
Received: by rv-out-0506.google.com with SMTP id k40so699982rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 12:16:23 -0700 (PDT)
Message-ID: <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com> (sfid-20080731_211628_063089_3060E6A3)
Date: Thu, 31 Jul 2008 22:16:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217528597.10489.150.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 9:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-31 at 21:14 +0300, Tomas Winkler wrote:
>> On Thu, Jul 31, 2008 at 4:05 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2008-07-30 at 19:08 +0300, Tomas Winkler wrote:
>> >
>> >> > Can you explain how starvation happens? In what scenarios? With or
>> >> > without aggregation?
>> >>
>> >> for (queue = 0; queue < QD_NUM(hw); queue++)
>> >>
>> >> This always starts 0  prioritize dequeue the first frame. But what we
>> >> need is RR and let HW to prioritize the transmission according AC
>> >
>> > That's from the old code not having real MQ though, right? I'm totally
>> > not concerned about that.
>>
>> Correct. The bottom line is that correct behavior MQ would be shift
>> scheduling decision to the HW.
>
> Right. Which brings us back to the original point, why does the hw need
> to make the scheduling decision between agg and non-agg?

There is no scheduling between aag and legacy queue in the sense of
qdisc .The aggregation need to be taken from single stream as
explained before,
Iwlwifi has HW support for it that that's the whole story we just need
queueing support from the software buffering stopping and starting
queue and last but not least there is a classification just an
extension of the regular AC scheduling.  The fairness between legacy
and agg queue must be provided by actually 'not scheduling'
If you don't want to experiment but provide QoS by spec the scheduling
is best to leave to HW.

Thanks
Tomas
