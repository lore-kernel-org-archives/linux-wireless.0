Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbbJZRkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 13:40:51 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 08/16] rtl8xxxu: Extract TX power fields from struct rtl8xxu_priv
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-9-git-send-email-jsitnicki@gmail.com>
	<wrfjbnbtvv6y.fsf@redhat.com> <87oafpe15t.fsf@frog.home>
Date: Mon, 26 Oct 2015 13:40:50 -0400
In-Reply-To: <87oafpe15t.fsf@frog.home> (Jakub Sitnicki's message of "Fri, 23
	Oct 2015 23:16:14 +0200")
Message-ID: <wrfjlhap34v1.fsf@redhat.com> (sfid-20151026_184056_494288_A59F5CCB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> On Wed, Oct 21, 2015 at 03:58 AM CEST, Jes Sorensen
> <Jes.Sorensen@redhat.com> wrote:
>> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 95
>>> ++++++++++++------------
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 30 ++++----
>>>  2 files changed, 66 insertions(+), 59 deletions(-)
>>
>> I don't really see this patch adding any value - it just adds an
>> additional layer of convolution. Unless there is a strong reason for
>> applying it, I am going to drop this one.
>
> The reasoning behind this change, which I should have had explained in
> the commit description, is to later on have a union of two struct
> *_tx_power's:
>
>   	union {
>   		struct rtl8723au_tx_power tx_power8723;
> 		struct rtl8188eu_tx_power tx_power8188;
>   	} tx_power;
>
> We arrive at this in the last patch from this series ("rtl8xxxu:
> rtl8188eu: Implement parse_efuse()").
>
> The existing *_tx_power_* fields in struct rtl8xxxu_priv don't fit the
> rtl8188eu needs because the vendor driver divides the 2.4 GHz channels
> into 6 as opposed to 3 groups (see the MAX_CHNL_GROUP_24G constant and
> struct txpowerinfo24g in staging/rtl8188eu).
>
> I agree that it does complicate the core structure (rtl8xxxu_priv) for
> no reason until there is actually support for RTL8188EU.  However, I
> gave the rtl8192eu driver a glance, and it looks like you might be
> facing the same challenge there.

Jakub,

I see, looks like 8723bu has the same number of groups as well. An
alternative solution would be to do the conversion in parse_efuse() and
explode the values into per-channel arrays instead of keeping them in
groups. That should simplify the runtime portion of the code.

Cheers,
Jes
