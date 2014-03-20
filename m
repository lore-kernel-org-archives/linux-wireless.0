Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52938 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTHvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 03:51:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jouni Malinen <jkmalinen@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] ath10k: add soft/hard firmware crash option to simulate_fw_crash
References: <20140313082431.10798.10888.stgit@potku.adurom.net>
	<87pplih81g.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmaxQj+Bv_dQz-+UmrG+7rmz_pTAZAGLY9_Mi_k7JP6HA@mail.gmail.com>
	<CANe27jJgu7QP9r7GGvnDnDp=7aVmMaJLGPqJVPRyo-E8epYACA@mail.gmail.com>
Date: Thu, 20 Mar 2014 09:51:49 +0200
In-Reply-To: <CANe27jJgu7QP9r7GGvnDnDp=7aVmMaJLGPqJVPRyo-E8epYACA@mail.gmail.com>
	(Jouni Malinen's message of "Wed, 19 Mar 2014 14:41:11 +0200")
Message-ID: <87lhw5fgtm.fsf@kamboji.qca.qualcomm.com> (sfid-20140320_085219_690925_3C45D49C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <jkmalinen@gmail.com> writes:

> On Wed, Mar 19, 2014 at 11:16 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>
>> On 19 March 2014 10:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> > Fengguan's buildbot got warnings here and I assume they are coming from
>> > smatch:
>> >
>> > drivers/net/wireless/ath/ath10k/debug.c:500 ath10k_write_simulate_fw_crash() error: strncmp() '"hard"' too small (5 vs 32)
>> > drivers/net/wireless/ath/ath10k/debug.c:497 ath10k_write_simulate_fw_crash() error: strncmp() '"soft"' too small (5 vs 32)
>> >
>> > I wanted to use strncmp() instead of strcmp(), but I'm not sure what to
>> > do here. In my opinion it's guaranteed that the string "hard" is null
>> > terminated, so it shouldn't matter even if strlen("soft") (5) is less
>> > than sizeof(buf) (32), right? Or am I missing something here?
>>
>> Hmm.. strncmp() compares *at most* n chars. The above means you can
>> overflow the const char[] "hard" and "soft" if `buf` is longer than
>> those. strncmp() must be passed the smallest length of either
>> argument.
>
> No you cannot. strncmp() will stop at '\0' from either buffer. If buf
> is nul terminated, I see no point in using strncmp here (i.e., strcmp
> should be used instead). If buf is not nul terminated, the length to
> strncmp() must be the correct length of data in that buf, not
> sizeof(buf). In either case, the current version here is incorrect
> (even if it could not result in a buffer read overflow in practice).

The reason why I changed strcmp() to strncmp() was to avoid the case if
someone accidentally removes "- 1" from the copy. I think this is just
too subtle for mistakes:

	char buf[32] = {};

        [...]

	/* Don't copy over the last byte, keep it initialised to zero to
	 * make sure that the buffer is properly null terminated. */
	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);

So I considered strncmp() just as an extra layer of protection (it has a
limit for the loop). But now that I think more about this, maybe this is
safer:

	char buf[10];

        [...]

	simple_write_to_buffer(buf, sizeof(buf), ppos, user_buf, count);

        /* make sure buf is null terminated */
        buf[sizeof(buf) - 1] = 0;

But anyway, I'll change the patch to use strcmp() again.

-- 
Kalle Valo
