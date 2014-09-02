Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33425 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaIBHb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:31:58 -0400
Received: by mail-pa0-f53.google.com with SMTP id fa1so14161813pad.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 00:31:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409597534.2703.9.camel@jlt4.sipsolutions.net>
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
	<1409597534.2703.9.camel@jlt4.sipsolutions.net>
Date: Tue, 2 Sep 2014 09:31:56 +0200
Message-ID: <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com> (sfid-20140902_093201_557380_A8256D8F)
Subject: Re: wmediumd performance penalty
From: Dani Camps <danicamps81@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am running on a virtual machine with Ubuntu. Does mac80211_hwsim not
schedule the packet reception time to the other radio(s) according to
the PHY rate in the packet in order to simulate transmission time over
the air ?

Best Regards

Daniel

On Mon, Sep 1, 2014 at 8:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-09-01 at 17:38 +0200, Dani Camps wrote:
>> Dear all,
>>
>> I am testing a simple 1-hop mesh network over wmediumd. The PHY rate I
>> have configured is 54 Mbps, and there is no loss, however the max
>> throughput I get is around 14 Mbps. Without wmediumd I get around 30
>> Mbps, which seems reasonable given the 54 PHY rate. As I noted above
>> there is no loss probability configured in wmediumd.
>>
>> My impression is that the performance drop is due to the overhead of
>> switching between kernel and user space in wmediumd, however it
>> surprises me that the penalty is so high.
>>
>> Has anyone had a similar experience? Could there be a way to overcome
>> this bottleneck?
>
> What kind of system are you running on? The virtual PHY rate isn't taken
> into account at all, so you should see far higher performance.
>
> johannes
>
