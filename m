Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38406 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0LAQzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 11:55:10 -0500
Received: by fxm20 with SMTP id 20so248832fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 08:55:08 -0800 (PST)
Message-ID: <4CF67DE3.7090204@lwfinger.net>
Date: Wed, 01 Dec 2010 10:54:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com> <AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com> <201012011540.45031.helmut.schaa@googlemail.com>
In-Reply-To: <201012011540.45031.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2010 08:40 AM, Helmut Schaa wrote:
> Hi,
> 
> Am Mittwoch 01 Dezember 2010 schrieb Mohammed Shafi:
>> On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>>> The last_tx_rate field was also updated for non-data frames that are
>>> often sent with a lower rate (for example management frames at 1 Mbps).
>>> This is confusing when the data rate is actually much higher.
>>>
>>> Hence, only update the last_tx_rate field with tx rate information
>>> gathered from the last data frames.
>>
>> Hi Helmut,
>>             I have a doubt,ideally should not this be taken care by the driver ?
> 
> Sorry, I don't get your point. How should that be handled by the driver? Could
> you please elaborate?
> 
> last_tx_rate is part of the sta_info struct and is documented as:
> 
> 207  * @last_tx_rate: rate used for last transmit, to report to userspace as
> 208  *      "the" transmit rate
> 
> So, the fields sole purpose is to report the "current" tx rate to user space.
> A normal user (IMO) would like to see the current tx rate that is used for
> data frames and not occasionally a 1Mbps because a management frame was the
> last sent frame.

In the openSUSE forums, we occasionally get a confused user that says "the
wireless only runs at 1 Mb/s" because that is what iwconfig says. On inspection,
the throughput is much higher. I vote for reporting the last data frame rate and
ignore management frames.
