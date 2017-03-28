Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35680 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755801AbdC1T1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 15:27:36 -0400
Received: by mail-it0-f52.google.com with SMTP id y18so126423832itc.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 12:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANr77M0xc=zD17HK1Gu2GT7Y_P=QC65UrHkvwj+JntenHSHNSA@mail.gmail.com>
References: <CANr77M0xc=zD17HK1Gu2GT7Y_P=QC65UrHkvwj+JntenHSHNSA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 29 Mar 2017 00:57:09 +0530
Message-ID: <CABPxzYKF4+M_cooukAA5oKJu0quB4CjOHaRr1qQjHMRYAPhE4A@mail.gmail.com> (sfid-20170328_212809_365083_EB0CE98C)
Subject: Re: Formatting of db.txt
To: Matthew Stanger <matthew_stanger@trimble.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:41 PM, Matthew Stanger
<matthew_stanger@trimble.com> wrote:
> Hi,
>
> I'm trying to set antenna gain in the db.txt following the
> documentation from:
> https://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules
>
> If I copy the example exactly show in the link:
>
> country CR:
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5170 - 5250 @ 20), (3, 17)
>         (5250 - 5330 @ 20), (3, 23), DFS
>         (5735 - 5835 @ 20), (3, 30)
>
> and do a make I get a parsing error:
> dbparse.SyntaxError: Syntax error in line 288 (invalid power data)
> make: *** [regulatory.bin] Error 1
>
>  I can change freq and power levels and other settings and everything
> builds fine. What am I missing about setting antenna gain?
the (max_eirp, pwr) is an old syntax which is deprecated by commit
https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/commit/?id=e56cd9618e3e5bf8ff96b799544b85170e34d9c3

May be we should update the doc.
