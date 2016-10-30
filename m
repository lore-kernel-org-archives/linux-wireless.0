Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35922 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756531AbcJ3N5C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 09:57:02 -0400
Received: by mail-wm0-f68.google.com with SMTP id c17so14657346wmc.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2016 06:57:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfjpomidp1v.fsf@redhat.com>
References: <cover.1477769750.git.john@zgus.com> <20161030102112.GA5789@cube> <wrfjpomidp1v.fsf@redhat.com>
From: John Heenan <john@zgus.com>
Date: Sun, 30 Oct 2016 23:56:59 +1000
Message-ID: <CAAye0QN0s1S25tDPNWdM6fsVNaO-wLuSy_RoOSoXeuSMeD4oNA@mail.gmail.com> (sfid-20161030_145902_424721_48DF0469)
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine macpower
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your reply.

The code was tested on a Cube i9 which has an internal rtl8723bu.

No other devices were tested.

I am happy to accept in an ideal context hard coding macpower is
undesirable, the comment is undesirable and it is wrong to assume the
issue is not unique to the rtl8723bu.

Your reply is idealistic. What can I do now?  I should of course have
factored out other untested devices in my patches. The apparent
concern you have with process over outcome is a useful lesson.

We are not in an ideal situation. The comment is of course relevant
and useful to starting a process to fixing a real bug I do not have
sufficient information to refine any further for and others do. In the
circumstances nothing really more can be expected.

My patch cover letter, [PATCH 0/2] provides evidence of a mess with
regard to determining macpower for the rtl8723bu and what is
subsequently required. This is important.

The kernel driver code is very poorly documented and there is not a
single source reference to device documentation. For example macpower
is noting more than a setting that is true or false according to
whether a read of a particular register return 0xef or not. Such value
was never obtained so a full init sequence was never performed.

It would be helpful if you could provide a link to device references.
As it is, how am I supposed to revise the patch without relevant
information?

My patch code works with the Cube i9, as is, despite a lack of
adequate information. Before it did not. That is a powerful statement

Have a nice day.

John Heenan


On 30 October 2016 at 22:00, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> John Heenan <john@zgus.com> writes:
>> Code tests show data returned by rtl8xxxu_read8(priv, REG_CR), used to set
>> macpower, is never 0xea. It is only ever 0x01 (first time after modprobe)
>> using wpa_supplicant and 0x00 thereafter using wpa_supplicant. These results
>> occurs with 'Fix for authentication failure' [PATCH 1/2] in place.
>>
>> Whatever was returned, code tests always showed that at least
>> rtl8xxxu_init_queue_reserved_page(priv);
>> is always required. Not called if macpower set to true.
>>
>> Please see cover letter, [PATCH 0/2], for more information from tests.
>>
>
> Sorry but this patch is neither serious nor acceptable. First of all,
> hardcoding macpower like this right after an if statement is plain
> wrong, second your comments violate all kernel rules.
>
> Second, you argue this was tested using code test - on which device? Did
> you test it on all rtl8xxxu based devices or just rtl8723bu?
>
> NACK
>
> Jes
