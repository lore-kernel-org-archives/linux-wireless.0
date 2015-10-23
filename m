Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbJWPiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 11:38:13 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 05/16] rtl8xxxu: Unbreak a user-visible string
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-6-git-send-email-jsitnicki@gmail.com>
	<wrfjk2qhvvs4.fsf@redhat.com> <87y4euruxt.fsf@frog.home>
Date: Fri, 23 Oct 2015 11:38:11 -0400
In-Reply-To: <87y4euruxt.fsf@frog.home> (Jakub Sitnicki's message of "Fri, 23
	Oct 2015 07:54:38 +0200")
Message-ID: <wrfjziz9egt8.fsf@redhat.com> (sfid-20151023_173819_710550_A9C0D199)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> On Wed, Oct 21, 2015 at 03:46 AM CEST, Jes Sorensen
> <Jes.Sorensen@redhat.com> wrote:
>> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>>> index cfb18db..e892fde 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>>> @@ -2002,8 +2002,8 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>>>  		/* We have 8 bits to indicate validity */
>>>  		map_addr = offset * 8;
>>>  		if (map_addr >= EFUSE_MAP_LEN_8723A) {
>>> -			dev_warn(dev, "%s: Illegal map_addr (%04x), "
>>> -				 "efuse corrupt!\n",
>>> +			dev_warn(dev,
>>> +				 "%s: Illegal map_addr (%04x), efuse corrupt!\n",
>>
>> This would make the line longer than 80 characters - so no.
>>
>> NAK
>
> Oh, okay.  In my defense, Your Honor, Documentation/CodingStyle made me
> do it ;-)
>
>   [...] However, never break user-visible strings such as printk
>   messages, because that breaks the ability to grep for them.

No worries, I am aware of that, I just don't like it so I break the
lines in reasonable places that still allow searching for them.

Cheers,
Jes
