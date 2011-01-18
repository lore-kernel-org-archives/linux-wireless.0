Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1ARD0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 22:26:36 -0500
Received: by iyj18 with SMTP id 18so5274791iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 19:26:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F4E1BA0D@SC-VEXCH1.marvell.com>
References: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
 <AANLkTi=BMTLa36FXW7nNHKu8=PgPCJC517vsmDDNZcYj@mail.gmail.com> <477F20668A386D41ADCC57781B1F704307F4E1BA0D@SC-VEXCH1.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 18 Jan 2011 14:26:15 +1100
Message-ID: <AANLkTi=UfKkYcX6CF9bQ84+anr74DKS-tXuH61NASObf@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 14:07, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Julian,
>
>> -----Original Message-----
>> From: Julian Calaby [mailto:julian.calaby@gmail.com]
>> Sent: Friday, January 14, 2011 6:59 PM
>> To: Bing Zhao
>> Cc: linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg; Amitkumar Karwar; Kiran Divekar;
>> Frank Huang
>> Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
>>
>> On Sat, Jan 15, 2011 at 06:36, Bing Zhao <bzhao@marvell.com> wrote:
>> > From: Amitkumar Karwar <akarwar@marvell.com>
>> >
>> > Some functions have unnecessory NULL check for an input parameter
>> > because the caller to those functions is already checking the parameter
>> > for NULL before calling them.
>>
>> It may be more readable and efficient to eliminate the NULL checks in
>> the callers - and adjust the code to inform the callers of the case
>> where the pointer passed is null and make the callers to properly
>> handle this case.
>
> Thank you very much for your comments.
>
> There are still some cases that the NULL check needs to be done at the first place. For example,
>
[snip]

In this case, dropping the null check is the right thing to do, given
that you can guarantee that all callers of mwiflex_init_cmd_node()
will check that the pointer isn't null before calling it.

>> This should also make the driver more robust as failures can be passed
>> up the stack to places that can deal with them more effectively than
>> just printing a message.
>
> I could have misunderstood your point, however. If so, could you please explain a little bit more on how you would make the changes based on above example?

I was referring more to that fact that functions that appear to do
things, e.g. mwifiex_init_cmd_node(), don't return anything - hence if
something fails within them, e.g. being passed a null pointer, they
can't notify their caller, e.g. mwifiex_prepare_cmd() that something
has gone wrong.

That said, I haven't looked at the code except through your patches,
so I can't say if this is a scenario that actually could happen, and
whether this added functionality is worthwhile.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
