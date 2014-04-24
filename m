Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34628 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaDXQpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 12:45:40 -0400
Received: by mail-lb0-f172.google.com with SMTP id p9so994214lbv.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 09:45:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70A2AB63@SC-VEXCH1.marvell.com>
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
	<1397710914-10061-2-git-send-email-bzhao@marvell.com>
	<CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
	<20140418044619.GF24166@us.netrek.org>
	<477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
	<20140419003410.GB14606@us.netrek.org>
	<20140424061137.GN1947@us.netrek.org>
	<477F20668A386D41ADCC57781B1F70430F70A2AB63@SC-VEXCH1.marvell.com>
Date: Thu, 24 Apr 2014 09:45:37 -0700
Message-ID: <CACUGKYMGVZyRHv7m90+3VJ3dAb6n0jvi=XHUYLUQh+1UAJgNQA@mail.gmail.com> (sfid-20140424_184605_875022_DDA715D8)
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
From: John Tobias <john.tobias.ph@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "quozl@laptop.org" <quozl@laptop.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

How did you know that by downgrading the firmware the problem has been
solved?. Did you see a scenario or flow in the driver that both
occurred when using the two different firmware but able to work on the
p80?.

The reason why I am asking is because sometimes the bug/s did not occur often.

Regards,

john


On Thu, Apr 24, 2014 at 12:28 AM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi James,
>
>> > > > I'm interested to know if the "firmware hangs" that you experiment
>> > > > with prevent autonomous RF TX, or if RF TX typically proceeds.
>> > >
>> > > It depends. Even if firmware hangs the hardware is still alive.
>> > > So you could see beacons and probe responses from the card if
>> > > hardware has been programmed before firmware hangs.
>> >
>> > Thanks.  I neglected to mention the time period; beacons and probe
>> > responses are seen for many minutes after the timeout report by the
>> > driver, and I have not yet tested for how long this lasts.  The probe
>> > responses are in reply to new probe requests.  It makes me think the
>> > card is working fine, apart from not communicating with the host.
>>
>> Downgrading wireless firmware to 14.66.9.p80 has fixed this problem.
>
> Wow! It means that p96 firmware had introduced the problem.
>
> Thanks,
> Bing
>
