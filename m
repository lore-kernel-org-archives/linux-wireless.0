Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:25573 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYJAWPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 18:15:13 -0400
Received: by rv-out-0506.google.com with SMTP id k40so817000rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 15:15:13 -0700 (PDT)
Message-ID: <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com> (sfid-20081002_001519_960775_AABE65BB)
Date: Wed, 1 Oct 2008 18:15:12 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <87ej30m376.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 1, 2008 at 5:10 PM, Elias Oltmanns <eo@nebensachen.de> wrot=
e:
> Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
>> Hello,
>>
>> the issue (initially reported in August 2008) still remains in the c=
urrent
>> kernel at my ThinkPad T41, a screen shot is attached. The steps to r=
eproduce
>> are :
>>
>> 1. modprobe it
>> 2. suspend the system to ram
>> 3. wake it up
>> 4. rmmod the driver
>
> Yes, I have run into this problem too. The patch below (applies to
> 2.6.27-rc8) fixes the problem, but since I'm not a wireless hacker,
> developers might prefer a different approach. Please let me know if I
> should change anything. Perhaps I should split this into two separate
> patches?

Thanks for the patch.  I do think a different approach is probably
warranted, though. ath5k_init() is supposed to be able to be called fro=
m
resume.  Do you have a better idea of why calib_tim isn't cleaned up
properly by ath5k_stop_hw?

I'm not near my laptop to test -- does the issue ever happen if you do
NOT suspend?

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
