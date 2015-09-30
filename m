Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37314 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbbI3X1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 19:27:41 -0400
Received: by wicfx3 with SMTP id fx3so4732098wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2015 16:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150930231613.GC20220@us.netrek.org>
References: <CABAco3AMgZSv9kCYkE6yQDcDE0+-7rA4ZzYazxSqAS99LHHMGQ@mail.gmail.com>
	<20150930231613.GC20220@us.netrek.org>
Date: Thu, 1 Oct 2015 01:27:40 +0200
Message-ID: <CABAco3Dd7urHu+y7J8TKYOXgh1QjRDvAp_Rs=q_gsU3f6Oum8Q@mail.gmail.com> (sfid-20151001_012744_989069_B3421ADE)
Subject: Re: [PATCH] iw: Memory leak in error condition
From: Ola Olsson <ola1olsson@gmail.com>
To: James Cameron <quozl@laptop.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh yes! :)
Suddenly valgrind was happy as well.

>From 2724dd259f2bf61a2b7c85a70a70fd640a583453 Mon Sep 17 00:00:00 2001
From: Ola Olsson <ola.olsson@sonymobile.com>
Date: Thu, 1 Oct 2015 00:43:06 +0200
Subject: [PATCH] iw: Memory leak in error condition Signed-off-by: Ola Olsson
 <ola.olsson@sonymobile.com>

---
 scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scan.c b/scan.c
index e959c1b..f3441a7 100644
--- a/scan.c
+++ b/scan.c
@@ -445,8 +445,11 @@ static int handle_scan(struct nl80211_state *state,

        if (ies || meshid) {
                tmpies = (unsigned char *) malloc(ies_len + meshid_len);
-               if (!tmpies)
+               if (!tmpies) {
+                       free(ies);
+                       free(meshid);
                        goto nla_put_failure;
+               }
                if (ies) {
                        memcpy(tmpies, ies, ies_len);
                        free(ies);
-- 
1.7.9.5

On Thu, Oct 1, 2015 at 1:16 AM, James Cameron <quozl@laptop.org> wrote:
> On Thu, Oct 01, 2015 at 01:01:18AM +0200, Ola Olsson wrote:
>> >From 5239e8e9aa79a131b716398efbf7a1203decbd9b Mon Sep 17 00:00:00 2001
>> From: Ola Olsson <ola.olsson@sonymobile.com>
>> Date: Thu, 1 Oct 2015 00:43:06 +0200
>> Subject: [PATCH] iw: Memory leak in error condition Signed-off-by: Ola
>>  Olsson <ola.olsson@sonymobile.com>
>>
>> ---
>>  scan.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/scan.c b/scan.c
>> index e959c1b..f248981 100644
>> --- a/scan.c
>> +++ b/scan.c
>> @@ -446,6 +446,8 @@ static int handle_scan(struct nl80211_state *state,
>>         if (ies || meshid) {
>>                 tmpies = (unsigned char *) malloc(ies_len + meshid_len);
>>                 if (!tmpies)
>> +                       free(ies);
>> +                       free(meshid);
>>                         goto nla_put_failure;
>
> Braces?  { }
>
>
>>                 if (ies) {
>>                         memcpy(tmpies, ies, ies_len);
>> --
>> 1.7.9.5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> James Cameron
> http://quozl.linux.org.au/
