Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:27858 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYJ2OlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 10:41:24 -0400
Received: by yx-out-2324.google.com with SMTP id 8so8113yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 07:41:23 -0700 (PDT)
Message-ID: <40f31dec0810290741t6378eebelbdacf4e5c8d63bff@mail.gmail.com> (sfid-20081029_154130_637219_8EBED96B)
Date: Wed, 29 Oct 2008 16:41:22 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Update PCU code
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <b6c5339f0810290705j36995186j382a8415886fb061@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081029021121.GA3079@makis>
	 <20081029024603.GA22759@hash.localnet>
	 <40f31dec0810290408h5ee08c8l1e14d576064f01a4@mail.gmail.com>
	 <b6c5339f0810290705j36995186j382a8415886fb061@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/29 Bob Copeland <me@bobcopeland.com>:
> On Wed, Oct 29, 2008 at 7:08 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> 2008/10/29 Bob Copeland <me@bobcopeland.com>:
>>> On Wed, Oct 29, 2008 at 04:11:22AM +0200, Nick Kossifidis wrote:
>>>>  * Properly clean MIC key from keytable when TKIP is used (Bob is
>>>>  working on set_key function etc so i leave it for now).
>>>
>>> Heh, I was just prepping patches to send out.  I had basically the
>>> same thing for _reset_key too so I'll just rebase mine on top of this.
>>>
>>
>> ACK, sorry for the bad coordination ;-(
>
> No worries, it was easy enough to drop that hunk.  But I do think this:
>
>> +       /* Reset associated MIC entry if TKIP
>> +        * is enabled located at offset (entry + 64) */
>> +       if (type == AR5K_KEYTABLE_TYPE_TKIP) {
>> +               entry = entry + AR5K_KEYTABLE_MIC_OFFSET;
>> +               AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
>> +               for (i = 0; i < AR5K_KEYCACHE_SIZE / 2 ; i++)
>> +                       ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
>> +       }
>> +
>
> ...should move a couple of lines down or use a temporary for the micentry
> slot; otherwise we are setting keytype to NULL in the mic entry and not
> the original key slot.
>

Yup you are right, we should set both to NULL so a temp micentry var
would do the trick.

Should i resend this one or you 'll resend yours ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
