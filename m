Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36552 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYUdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 15:33:45 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so478074wgb.8
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 12:33:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359143876.4655.19.camel@jlt4.sipsolutions.net>
References: <1359143275-28359-1-git-send-email-thomas@cozybit.com> <1359143876.4655.19.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 25 Jan 2013 12:33:23 -0800
Message-ID: <CAG6hwVPEpUCiyK0JZucTT0S7Ui6ZBBYWA58bKJQ9dWBN_LLg7A@mail.gmail.com> (sfid-20130125_213349_131043_15885DC8)
Subject: Re: [PATCH] cfg80211: don't dereference NULL chan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-01-25 at 11:47 -0800, Thomas Pedersen wrote:
>> The patch "cfg80211: check radar interface combinations"
>> would dereference chan even though this may be NULL. Fix a
>> page fault when adding a new interface by adding a
>> short-circuit check for NULL.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>
>> No action required for this to make it into 3.8, right?
>
> It doesn't have to go to 3.8 since the original patch isn't going there,

Oh then -next would be 3.9, duh.

> and I already have the same fix:
> 683d41ae6755e6ae297ec09603c229795ab9566e

Thanks!

-- 
Thomas
