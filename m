Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:45687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYKBIcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 03:32:14 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2033223rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 01:32:13 -0700 (PDT)
Message-ID: <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com> (sfid-20081102_093317_788593_3C23ADB6)
Date: Sun, 2 Nov 2008 10:32:13 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/1 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Wed, Oct 29, 2008 at 12:19 PM, Tim Gardner <tcanonical@tpi.com> wrote:
>> This commit 'ath5k: Update interrupt masking code' causes stalls under
>> load when built using compat-wireless on 2.6.27. There is no output from
>> dmesg, but it occasionally recovers and moves a few more packets before
>> stalling again. Luis suggested reverting
>> eb9d4e8399181357cb6f6625ba7f849987432c6c which I did. Now it appears to
>> work normally.
>>
>> I also think this patch should be broken into multiple pieces. There
>> appear to be at least 3 functional changes addressed in this single patch.
>
> Agreed, I just tested with the latest wireless-testing and the issue
> is still present. I reviewed the commit but its a big too large to pin
> point the exact issue, my AR5414 goes up but then quickly becomes
> unusable. Nick how about we revert this and you can then split this up
> into a good number of patches to make the review easier and also to be
> able to pin point the exact issue better?
>
> The SHA1 remains the same but just in case the title of the patch is:
>
>   ath5k: Update interrupt masking code
>
> With it reverted I'm cruising and can ditch MadWifi completely, which
> is the idea.
>
>  Luis
>

Code doesn't introduce many functional changes, we can't eg. patch
only the code that reads interrupt status and not the code that masks
interrupts etc. Also if you compare the code with legacy-hal you'll
see that legacy-hal does mostly the same (we just handle all cases and
have better abstraction on ath5k.h + the RXNOFRM/TXNOFRM trick) + most
of the code is about interrupts we don't enable anyway. Anyway i think
i found the problem (on base.c we don't unmask TXDESC on PIMR), i'll
do a few more tests and come back to you asap ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
