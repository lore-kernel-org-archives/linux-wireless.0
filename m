Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43792 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZFIJm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 05:42:59 -0400
Received: by gxk10 with SMTP id 10so2981175gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 02:43:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906081044x566514c5mc02299282e9c9ff2@mail.gmail.com>
References: <4A2CA986.3070500@gmail.com> <646765f40906072312y5043ac12rd6d756230e98b746@mail.gmail.com>
	<43e72e890906081044x566514c5mc02299282e9c9ff2@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 9 Jun 2009 19:42:41 +1000
Message-ID: <646765f40906090242m7c34adaaq8d89abf1ffc96c89@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: update for 2009-06-08
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 03:44, Luis R.
Rodriguez<mcgrof@winlab.rutgers.edu> wrote:
> On Sun, Jun 7, 2009 at 11:12 PM, Julian Calaby<julian.calaby@gmail.com> wrote:
>> On Mon, Jun 8, 2009 at 16:02, Julian Calaby<julian.calaby@gmail.com> wrote:
>>> Update to match wireless-testing v2.6.30-rc8-25759-g00f7164
>>>
>>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>>> ---
>>>  compat/compat.diff |   42 +++++++++++++++++++++++-------------------
>>>  1 files changed, 23 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/compat/compat.diff b/compat/compat.diff
>>> index d89ea98..846e8f5 100644
>>> --- a/compat/compat.diff
>>> +++ b/compat/compat.diff
>>> @@ -181,6 +181,12 @@
>>>  obj-$(CONFIG_LIBERTAS)                += libertas/
>>>
>>>  obj-$(CONFIG_LIBERTAS_THINFIRM)       += libertas_tf/
>>> +@@ -60,5 +34,3 @@
>>> + obj-$(CONFIG_MAC80211_HWSIM)  += mac80211_hwsim.o
>>> +
>>> + obj-$(CONFIG_WL12XX)  += wl12xx/
>>> +-
>>> +-obj-$(CONFIG_IWM)     += iwmc3200wifi/
>>
>> Sigh.
>>
>> Of course, I forgot to describe the changes in this patch.
>>
>> compat.diff has been updated to apply cleanly over the
>> wireless-testing.git version specified above with no fuzz.
>>
>> iwmc3200wifi, as I don't know if it compiles on anything but
>> wireless-testing.git, has been disabled by editing it out of the
>> Makefile as it's directory isn't actually copied from
>> wireless-testing. -- I'm not sure that this is the correct way to do
>> this as it's hiding the problem away in compat.diff - not obviously
>> fixing it by, e.g. copying the directory from wireless-testing.git or
>> making it compile on older kernels.
>
> This is fine for now.

Cool.

>> I must note that even after these changes, this still doesn't actually
>> compile for me, as ath9k uses the rfkill_ops structure which isn't
>> present in my 2.6.29 kernel.
>
> Thanks for the note, both patches applied. For rfkill we'll need
> someone brave and with time to backport it... as rfkill has been
> re-written. The easiest solution is to revert the patches for older
> kernels through compat.diff. That is add #ifdefs and for old kernel
> revisions use the old stuff, for new kernels (as of 2.6.31) leave the
> code in place.

Thanks for applying them.

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
