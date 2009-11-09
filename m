Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36078 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZKIWq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:46:57 -0500
Received: by bwz27 with SMTP id 27so4022805bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:47:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257805265.21134.22738.camel@rc-desk>
References: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
	 <1257787187.21134.22331.camel@rc-desk>
	 <cb0375e10911091007w45fa5653y8ed4f043f37074b6@mail.gmail.com>
	 <1257805265.21134.22738.camel@rc-desk>
Date: Mon, 9 Nov 2009 17:47:02 -0500
Message-ID: <cb0375e10911091447y375c276emddc5eff38b4b575e@mail.gmail.com>
Subject: Re: [PATCH] iwlcore: Allow runtime configuration of
	no_sleep_autoadjust
From: Andrew Lutomirski <andy@luto.us>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 5:21 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi Andrew,
>
> On Mon, 2009-11-09 at 10:07 -0800, Andrew Lutomirski wrote:
>> Hmm.  It looks like sleep_level_override in debugfs can do exactly what I want.
>
> You have not really stated what you are trying to do here so it is hard
> to tell. sleep_level_override lets you hardcode the power saving index.
>
>>
>> Is there any reason that no_sleep_autoadjust doesn't just make
>> sleep_level_override default to 1?
>
> That does seem what it is doing in iwl_power_update_mode().

I want to save power.  no_sleep_autoadjust=N and iwconfig wlan0 power
on does a good job of that.  I assume that no_sleep_autoadjust
defaults to Y because it's still not reliable (and I seem to have seen
a few networks where it causes occasional problems).  So I'd like to
be able to toggle it at runtime, file bug reports when it fails, but
still be able to use the networks it fails on :)

--Andy
