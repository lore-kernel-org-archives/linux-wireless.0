Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35542 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcAUTqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 14:46:19 -0500
Received: by mail-ob0-f173.google.com with SMTP id yo10so19081873obb.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 11:46:18 -0800 (PST)
Subject: Re: wireless-drivers: random cleanup patches piling up
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56A13587.7040809@lwfinger.net> (sfid-20160121_204622_842582_7021B1FD)
Date: Thu, 21 Jan 2016 13:46:15 -0600
MIME-Version: 1.0
In-Reply-To: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2016 08:58 AM, Kalle Valo wrote:
> Hi,
>
> I have quite a lot of random cleanup patches from new developers waiting
> in my queue:
>
> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date
>
> (Not all of them are cleanup patches, there are also few patches
> deferred due to other reasons, but you get the idea.)
>
> These cleanup patches usually take quite a lot of my time and I'm
> starting to doubt the benefit, compared to the time needed to dig
> through them and figuring out what to apply. And this is of course time
> away from other patches, so it's slowing down "real" development.
>
> I really don't know what to do. Part of me is saying that I just should
> drop them unless it's reviewed by a more experienced developer but on
> the other hand this is a good way get new developers onboard.
>
> What others think? Are these kind of patches useful?

Kalle,

We might get new developers, but the cost may be high. In the staging tree, 
things are worse. The tools can be applied in a blind fashion, but the results 
can be really stupid. GregKH has told a few would-be contributors to "go away" 
after a few patches that would not build.

As most of these patches are based on "problems" found by application of various 
standard tools, they will likely be resubmitted over and over until the code is 
"fixed". Whether the patches are useful may not be the main question.

My real complaint with these patches is that very few are more than compile 
tested. For example, there are 3 patches for memory leaks in b43. One 
(https://patchwork.kernel.org/patch/7998941) was rejected because it missed some 
such leaks, but there was not a formal NACK. The patch was fixed and resubmitted 
(https://patchwork.kernel.org/patch/8014311/), but not yet tested. The author 
then resent it (https://patchwork.kernel.org/patch/8049041/) and was chastised 
for resending as it still had not been tested. Of course, the first two of these 
can be dropped. Unfortunately, there are very few devs who have the necessary 
hardware to test.

Most of the current set do not account for the directory restructuring and will 
not apply.Those can be rejected with the appropriate message asking that they be 
rebased. That should not require too much of your time. That will at last clean 
out the current backlog.

Is it possible for us to require the patch author to supply the level of testing 
when that is not obvious? This information should be in the comments location 
after the first ---. I suspect I know the answer for non-maintainers, but the 
formal requirement might be helpful. I will start NACKing those patches without 
such information.

I also promise to be more diligent in reviewing the patches that are directed at 
the drivers that I maintain.

Larry


