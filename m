Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:57874 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3HGHmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:42:24 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so958290lab.22
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 00:42:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87li4e6l67.fsf@kamboji.qca.qualcomm.com>
References: <1375853036-2418-1-git-send-email-janusz.dziedzic@tieto.com>
	<87li4e6l67.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 7 Aug 2013 09:42:22 +0200
Message-ID: <CALhHN=pP32Vw6UMvS93cReWr6WHz3p_3d8mn0FNJtSQGvuGJ9w@mail.gmail.com> (sfid-20130807_094228_887708_E26D910A)
Subject: Re: [PATCH] ath10k: setup peer UAPSD flag correctly
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 August 2013 08:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Setup UAPSD peer rate control (FW flag)
>> correctly.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> This doesn't answer the question "Why?". I have now added a section in
> the wiki about what the commit log should contain. Hopefully that helps.
>
> Submitting patches
>
> Send patches to the mailing lists below. Kalle Valo reviews the patches
> within the next few days and, if they are ok, commits them to ath.git.
>
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
>
> Preferably use ath.git master as the baseline for patches. Other trees
> can be used as well, but then the chances of conflicts are higher.
>
> Guidelines for patches:
>
> * MUST be compiler warning free.
>
> * MUST be sparse warning free.
>
> * Commit log MUST not be empty.
>
> * The commit log MUST answer the question "Why?":
>
>   * Describe the motivation behind the bug.
>
>   * How does it change the functionality from user's point of view?
>
>   * Does it fix a bug? If it does, please describe the bug (doesn't need
>     to be long). Also if there's a public bug report add a link to the
>     bug report.
>
> * If others have reported the issue commit log SHOULD use Reported-by:
>   and Tested-by: tags.
>
> * SHOULD be checkpatch clean:
>
>   * FIXME: add checkpatch example with correct arguments
>
> * Patches SHOULD be sent with git send-email tool.
>
> * Patchsets SHOULD contain no more than 12 patches.
>
> The terminology is from http://www.ietf.org/rfc/rfc2119.txt
>
> http://wireless.kernel.org/en/users/Drivers/ath10k#Submitting_patches
>
> Please comment.
>

Setup UAPSD peer/peer rate flags correctly.
WMI_RC_UAPSD_FLAG is a peer rate capabilities flag
and should not be set as a peer flag.

BTW this don't fix any known bug yet, just found during UAPSD check.


BR
Janusz
