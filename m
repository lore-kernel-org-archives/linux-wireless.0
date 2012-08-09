Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62869 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2HIMwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 08:52:01 -0400
Received: by obbuo13 with SMTP id uo13so592625obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 05:52:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA2SeNLHW=wA9nVG5YS5938vO7nZCJxMT8KiJCooPrFkvrv77g@mail.gmail.com>
References: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com>
	<20120808164813.0011148e@mj>
	<CAA2SeNLHW=wA9nVG5YS5938vO7nZCJxMT8KiJCooPrFkvrv77g@mail.gmail.com>
Date: Thu, 9 Aug 2012 18:21:59 +0530
Message-ID: <CAD2nsn3qwus1fZiGrcTmOiEOqPJHKDhHXmuJd7c=WWK5U=5JNw@mail.gmail.com> (sfid-20120809_145205_491197_7AF8D1C9)
Subject: Re: [PATCH 1/1] ath9k: decrypt_error flag issue
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 5:57 PM, Lorenzo Bianconi
<lorenzo.bianconi83@gmail.com> wrote:
>> On Wed, 8 Aug 2012 19:20:15 +0200
>> Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> wrote:
>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>>> ---
>>
>> Please see Documentation/SubmittingPatches in Linux sources.  In
>> particular, you separated the description of the patch from its
>> contents.  Single patch doesn't need to be send as series.  The
>> description for the series is not a substitute for a description of
>> every patch.
>>
>> Also, the subject should summarize the patch.  I know, it may be hard
>> to fit, but not impossible.
>>
>
> Ack. I will rewrite the mail.

more help
http://linuxwireless.org/en/developers/Documentation/git-guide :)

>
>> When exactly would you have the problem that decrypt_error is not
>> unset, but should be?  It's important that you show your assumptions so
>> that others can see if they are correct, in addition to checking the
>> code.  Other developers are more likely to check your patch if you
>> show understanding of the code you have changed.
>>
>
> Assume hw reports a decryption error, the flag decrypt_error is set to
> true in ath9k_rx_accept.
> Since this flag is initialized to false just out of  ath_rx_tasklet while cycle,
> all subsequent frames are marked as corrupted until ath_rx_tasklet ends.

seems to be a nice catch!
It would be great if we can simulate this situation (ie
decrypt_error is set to true, and subsequent frames are discarded)
may be we can try this some time, purposefully setting the decrypt_error 'true'
for the first instance and see if there is data loss/throughput diff
because of this.


>
>
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -1780,7 +1780,6 @@
>>
>> That's weird, recv.c is 1273 lines long in wireless-testing.git.

yeah you got to commit the patches by cloning the latest wireless testing
git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git


-- 
thanks,
shafi
