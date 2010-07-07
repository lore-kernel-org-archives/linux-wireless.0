Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38197 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0GGVLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 17:11:10 -0400
MIME-Version: 1.0
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6BD@CHEXMB-01.global.atheros.com>
References: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6BD@CHEXMB-01.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 7 Jul 2010 14:10:49 -0700
Message-ID: <AANLkTimNMRDTpqB2l-c4nTfUiEbPGb2XxfE5E83YDfY7@mail.gmail.com>
Subject: Re: [PATCH] compat: Fix panic caused by NULL pointer derefence in
	rtnl_fill_ifinfo
To: Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 29, 2010 at 9:26 AM, Rajkumar Manoharan
<Rajkumar.Manoharan@atheros.com> wrote:
>>________________________________________
>>From: Luis R. Rodriguez [mcgrof@gmail.com]
>>Sent: Tuesday, June 29, 2010 8:51 PM
>>To: Rajkumar Manoharan
>>Cc: mcgrof@kernel.org; linux-wireless@vger.kernel.org; linux-bluetooth@vger.kernel.org
>>Subject: Re: [PATCH] compat: Fix panic caused by NULL pointer derefence in      rtnl_fill_ifinfo
>
>>On Mon, Jun 28, 2010 at 11:38 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
>> get stats netdev ops is blindy called for older kernels (< 2.6.29) and
>> so assigning a NULL pointer from netdev_attach_ops causes a NULL pointer
>> dereference.
>>
>> By default, netdev alloc provides an internal stats reference. So fill
>> this only if ndo_get_stats is defined.
>>
>> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
>> ---
>>  compat/compat-2.6.29.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
>> index f94aed8..2e7e623 100644
>> --- a/compat/compat-2.6.29.c
>> +++ b/compat/compat-2.6.29.c
>> @@ -35,7 +35,8 @@ void netdev_attach_ops(struct net_device *dev,
>>        dev->change_mtu = ops->ndo_change_mtu;
>>        dev->set_mac_address = ops->ndo_set_mac_address;
>>        dev->tx_timeout = ops->ndo_tx_timeout;
>> -       dev->get_stats = ops->ndo_get_stats;
>> +       if (ops->ndo_get_stats)
>> +               dev->get_stats = ops->ndo_get_stats;
>>
>> If ops->ndo_get_stats is NULL then dev->get_stats will be set to NULL.
>> Do you know for sure this fixes something? If so can you explain how?
>> I used to have a macro that checked for not NULL and if true set the
>> callback but then later realized after Johannes poked me that this is
>> silly given that if the op is NULL you are just setting it to NULL.
>>
>> I don't see the potential crash here.
>>
>>  Luis
>
> During alloc_netdev, get_stats is set to default callback (internal_stats).
> It won't be NULL. Based on this assumption, get_stats is
> invoked blindly in rtnl_fill_ifinfo without NULL check. So either
> get_stats set with default callback or callback assigned by module.
> It shouldn't be NULL.

Fun, thanks! Patch applied, and propagated to the  linux-2.6.35.y
stable branch of compat as well.

  Luis
