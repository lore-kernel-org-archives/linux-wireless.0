Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36801 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751820AbdC2DtO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 23:49:14 -0400
Received: by mail-qk0-f173.google.com with SMTP id p22so3057420qka.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 20:49:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKF4+M_cooukAA5oKJu0quB4CjOHaRr1qQjHMRYAPhE4A@mail.gmail.com>
References: <CANr77M0xc=zD17HK1Gu2GT7Y_P=QC65UrHkvwj+JntenHSHNSA@mail.gmail.com>
 <CABPxzYKF4+M_cooukAA5oKJu0quB4CjOHaRr1qQjHMRYAPhE4A@mail.gmail.com>
From: Matthew Stanger <matthew_stanger@trimble.com>
Date: Tue, 28 Mar 2017 21:49:12 -0600
Message-ID: <CANr77M2fspR0fk-kDrfaF6ONcZmdzyVk3G5f6NywZ5-PRkFCwA@mail.gmail.com> (sfid-20170329_054926_640389_BDFEC74B)
Subject: Re: Formatting of db.txt
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I also notice when I run 'iw reg get' it still shows the format which
seems to support the antenna gain (N/A):
country US: DFS-FCC
        (2402 - 2472 @ 40), (N/A, 25), (N/A)
        (5170 - 5250 @ 80), (N/A, 16), (N/A)
        (5250 - 5330 @ 80), (N/A, 16), (N/A)
        (5490 - 5730 @ 160), (N/A, 16), (N/A)
        (5735 - 5835 @ 80), (N/A, 23), (N/A)

If this isn't supported by the .db anymore then maybe this format
should be updated in configuration utility. Am I on track? I'd be glad
to attempt a patch if this is of value? Thanks

Cheers,

On Tue, Mar 28, 2017 at 1:27 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Tue, Mar 28, 2017 at 10:41 PM, Matthew Stanger
> <matthew_stanger@trimble.com> wrote:
>> Hi,
>>
>> I'm trying to set antenna gain in the db.txt following the
>> documentation from:
>> https://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules
>>
>> If I copy the example exactly show in the link:
>>
>> country CR:
>>         (2402 - 2482 @ 40), (N/A, 20)
>>         (5170 - 5250 @ 20), (3, 17)
>>         (5250 - 5330 @ 20), (3, 23), DFS
>>         (5735 - 5835 @ 20), (3, 30)
>>
>> and do a make I get a parsing error:
>> dbparse.SyntaxError: Syntax error in line 288 (invalid power data)
>> make: *** [regulatory.bin] Error 1
>>
>>  I can change freq and power levels and other settings and everything
>> builds fine. What am I missing about setting antenna gain?
> the (max_eirp, pwr) is an old syntax which is deprecated by commit
> https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/commit/?id=e56cd9618e3e5bf8ff96b799544b85170e34d9c3
>
> May be we should update the doc.
