Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:59451
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZBCASy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 19:18:54 -0500
Message-ID: <49878D6B.7050707@erley.org> (sfid-20090203_011858_563778_85407C43)
Date: Mon, 02 Feb 2009 19:18:51 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [patch] iw: align output for HT capabilities
References: <49878B8B.4020005@erley.org> <646765f40902021615v521d0031y27885b56a74fd2f2@mail.gmail.com>
In-Reply-To: <646765f40902021615v521d0031y27885b56a74fd2f2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote:
> On Tue, Feb 3, 2009 at 11:10, pat-lkml <pat-lkml@erley.org> wrote:
>> The HT capabilities have an additional space in front of them causing
>> them not to line up with the rest of the listed outputs.  This patch
>> removes that space.
>>
>> Signed-off-by: Pat Erley <pat-lkml@erley.org>
>>
>> ---
>>
>> diff --git a/info.c b/info.c
>> index bf3b8bd..69be500 100644
>> --- a/info.c
>> +++ b/info.c
>> @@ -70,7 +70,7 @@ static int print_phy_handler(struct nl_msg *msg, void
>> *arg)
>>  #ifdef NL80211_BAND_ATTR_HT_CAPA
>>                if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
>>                        unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
>> -#define PCOM(fmt, args...) do { printf("\t\t\t * " fmt "\n", ##args); }
>> while (0)
>> +#define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); }
>> while (0)
> 
> Is it just me or is this patch line-wrapped?
> 
> Thanks,
> 
no, it line wrapped.  Weird that it'd line wrap the function def but not
the line later on me, but I guess it's time to look into fixing my mail
client.

Thanks,
Pat
