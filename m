Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34545 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbcE0SH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 14:07:59 -0400
Received: by mail-yw0-f169.google.com with SMTP id c127so113127039ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 11:07:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFiGRCH9LE+7vkkQonJ4YfvbitxWT+OJfFWrV1hZ5ZE_5-j-tQ@mail.gmail.com>
References: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com>
 <CAFiGRCH9LE+7vkkQonJ4YfvbitxWT+OJfFWrV1hZ5ZE_5-j-tQ@mail.gmail.com>
From: Aurimas Liutikas <aurimas@google.com>
Date: Fri, 27 May 2016 11:07:56 -0700
Message-ID: <CAFiGRCGXeLg3vhuCb0-=pRojvmeuuBmP03D=LX=Kbav=q3ULZA@mail.gmail.com> (sfid-20160527_200803_272004_D63CF080)
Subject: Re: [PATCH] iw: Fix -Wabsolute-value compiler warning in iw.c
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello again! I was curious if this looks like a reasonable change?

Aurimas

On Wed, May 18, 2016 at 9:12 AM, Aurimas Liutikas <aurimas@google.com> wrote:
> Hey there! Any thoughts on this patch?
>
> Aurimas
>
> On Thu, May 12, 2016 at 9:16 AM, Aurimas Liutikas <aurimas@google.com> wrote:
>> Signed-off-by: Aurimas Liutikas <aurimas@google.com>
>>
>> diff --git a/iw.c b/iw.c
>> index 2aabddb..a6efe5b 100644
>> --- a/iw.c
>> +++ b/iw.c
>> @@ -516,7 +516,7 @@ int main(int argc, char **argv)
>>         const struct cmd *cmd = NULL;
>>
>>         /* calculate command size including padding */
>> -       cmd_size = abs((long)&__section_set - (long)&__section_get);
>> +       cmd_size = labs((long)&__section_set - (long)&__section_get);
>>         /* strip off self */
>>         argc--;
>>         argv0 = *argv++;
>
>
>
> --
>
>  Aurimas Liutikas | Software Engineer | Chrome / Google



-- 
--
Aurimas Liutikas
