Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47446 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZIBQlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 12:41:35 -0400
Received: by fxm17 with SMTP id 17so920121fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 09:41:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251906970.13180.137.camel@rc-desk>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
Date: Wed, 2 Sep 2009 12:41:37 -0400
Message-ID: <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Andrew Lutomirski <luto@mit.edu>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 2, 2009 at 11:56 AM, reinette
chatre<reinette.chatre@intel.com> wrote:
> Hi Andy,
>
> On Wed, 2009-09-02 at 07:53 -0700, Andrew Lutomirski wrote:
>> Right now, enabling power saving on iwlwifi is impossible, because
>> mac80211 won't tell iwlwifi that power saving is on (since
>> IEEE80211_HW_SUPPORTS_PS is not set) and iwlwifi will ignore the
>> user's power_level setting until mac80211 asks for power saving.
>> Setting this flag allows the user to manually enable power saving if
>> desired.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>>
>> ---
>
> nack.
>
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2053 and
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2051 are two
> examples of what happens if power save support is enabled. In addition
> to this we are also seeing issues with 4965 that are described in the
> commit that disabled powersave in 2.6.31 in the first place
> (286d94906587901851906a5e2ddc09bc1a7ba1d9).
>

Fair enough.  Would you accept a patch to remove power_level from sysfs instead?

>
>> This fixes what looks to me like a regression: power_level used to
>> work but now fails silently.  In 2.6.32 I think this code is going
>> away, but this patch seems like a safe stopgap measure.
>
> 2.6.32 will have power save support disabled also.

Any ETA for getting this fixed for real?  I like my battery life :)

--Andy
