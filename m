Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63437 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1GUUaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 16:30:00 -0400
Received: by qyk9 with SMTP id 9so942557qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 13:29:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110715T233642-162@post.gmane.org>
References: <1308801053-2461-1-git-send-email-lrodriguez@atheros.com> <loom.20110715T233642-162@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jul 2011 13:29:39 -0700
Message-ID: <CAB=NE6VHu2snkHtkr8wNq=PnJ=4O7du2yWgLaN+wTzacZ-fRng@mail.gmail.com> (sfid-20110721_223005_919719_BA79AA73)
Subject: Re: [PATCH 0/4] hostapd: add ACS support
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:38 PM, Swaminathan Vasanth
<swaminathanvasanth.r@gmail.com> wrote:
>> Other algorithms for ACS shoudl be easy to plug in, for example,
>> spectral scan ;)
>>
>> Anyway, to enable and test this thing just set CONFIG_ACS=1
>> on your build config and then something like this on your
>> hostapd.conf:
>>
>> channel=acs_survey
>> acs_num_req_surveys=10
>> acs_roc_duration_ms=100
>>
>> Test results, rants are appreciated.
>>
>
> Hi,
>
>  I am trying to enable the Auto Channel Selection in hostapd with ath5k and
> ath9k drivers. I cloned the source of hostap from the git and applied the patch
> (
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/hostapd/acs-all-in-one-v2.patch
> ). I then went to the hostapd directory of hostap and did make and make install.
> Followed instruction from (
> http://wireless.kernel.org/en/users/Documentation/hostapd#Download_and_compile_hostapd
> ).
>
> While building the software i enabled CONFIG_ACS=y in  the defconfig file
> present in /hostap/hostapd/ to .config and performed the build. I then did a
> make install and configured the hostapd.conf file.
>
> Hostapd is working fine for me without ACS but when i enable channel=0 or
> channel=acs_survey and uncomment the
>
> acs_num_req_surveys=10
> acs_roc_duration_ms=5
>
> options for ACS to be enabled it throws this error when starting hostapd,
>
>
>> sudo hostapd hostapd.conf
>
> Configuration file: hostapd.conf
> Line 113: set as '0' tries to enable ACS but CONFIG_ACS disabled
> Line 125: invalid acs_num_req_surveys 10 (CONFIG_ACS disabled)
> Line 126: invalid acs_roc_duration_ms 5 (CONFIG_ACS disabled)1..5000)
> 3 errors found in configuration file 'hostapd.conf'
>
> Infact i enabled CONFIG_ACS when building.

Hmm, try:

make V=1 | grep -i ACS

> Any pointers on what to do to enable ACS please.
>
> Awaiting your kind reply.

I'm about to respin these patches to apply to the latest hostapd.git
with 1 fix. Try that.

  Luis
