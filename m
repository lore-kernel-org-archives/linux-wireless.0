Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:49393 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYJOIKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 04:10:05 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1441423tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 01:10:03 -0700 (PDT)
Message-ID: <ea11fea30810150110s772b740fv38cc37645da53201@mail.gmail.com> (sfid-20081015_101012_936383_4BE67F0D)
Date: Wed, 15 Oct 2008 13:40:03 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] libertas : Remove unused variable warning "old_channel" from drivers/net/wireless/libertas/cmd.c
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <1224002213.1799.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
	 <1224002213.1799.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 10:06 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-10-13 at 16:22 +0530, Manish Katiyar wrote:
>> Below patch removes the following warning during compilation.
>>
>> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old_channel'
>>
>>
>> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
>
> Acked-by: Dan Williams <dcbw@redhat.com>

Hi Dan,

A newbie question. Will you merge this patch or will I have to send it
to Andrew again acked by you ?

Thanks -
Manish


>
>> ---
>>  drivers/net/wireless/libertas/cmd.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/libertas/cmd.c
>> b/drivers/net/wireless/libertas/cmd.c
>> index a912fb6..297696d 100644
>> --- a/drivers/net/wireless/libertas/cmd.c
>> +++ b/drivers/net/wireless/libertas/cmd.c
>> @@ -823,7 +823,9 @@ int lbs_update_channel(struct lbs_private *priv)
>>  int lbs_set_channel(struct lbs_private *priv, u8 channel)
>>  {
>>       struct cmd_ds_802_11_rf_channel cmd;
>> +#ifdef DEBUG
>>       u8 old_channel = priv->curbssparams.channel;
>> +#endif
>>       int ret = 0;
>>
>>       lbs_deb_enter(LBS_DEB_CMD);
>
>
