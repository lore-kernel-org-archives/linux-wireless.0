Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbcHLOam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 10:30:42 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: sunbing <sunbing@redflag-linux.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is variable issue
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
	<wrfja8gje395.fsf@redhat.com>
	<7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com>
Date: Fri, 12 Aug 2016 10:30:34 -0400
In-Reply-To: <7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com>
	(sunbing@redflag-linux.com's message of "Fri, 12 Aug 2016 06:50:03
	+0800")
Message-ID: <wrfj7fbmawl1.fsf@redhat.com> (sfid-20160812_163100_941697_4910C486)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sunbing <sunbing@redflag-linux.com> writes:
> On Aug 11, 2016, at 23:25, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>
>> Bing Sun <sunbing@redflag-linux.com> writes:
>>> Fixed sparse parse error:
>>> Expected constant expression in case statement.
>>> 
>>> Signed-off-by: Bing Sun <sunbing@redflag-linux.com>
>>> ---
>>> drivers/staging/rtl8723au/os_dep/os_intfs.c | 11 +++++------
>>> 1 file changed, 5 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
>>> index b8848c2..f30d5d2 100644
>>> --- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
>>> +++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
>>> @@ -283,14 +283,13 @@ static u32 rtw_classify8021d(struct sk_buff *skb)
>>> 	 */
>>> 	if (skb->priority >= 256 && skb->priority <= 263)
>>> 		return skb->priority - 256;
>>> -	switch (skb->protocol) {
>>> -	case htons(ETH_P_IP):
>>> +
>>> +	if (skb->protocol == htons(ETH_P_IP)) {
>>> 		dscp = ip_hdr(skb)->tos & 0xfc;
>>> -		break;
>>> -	default:
>>> -		return 0;
>>> +		return dscp >> 5;
>>> 	}
>>> -	return dscp >> 5;
>>> +
>>> +	return 0;
>>> }
>> 
>> Pardon me here, but I find it really hard to see how this change is an
>> improvement over the old code in any shape or form.
>> 
>> Jes
>
> There is no functional improvement. 
> But before this patch, when we do: make C=1 M=drivers/staging/rtl8723au/
> An error output: 
> drivers/staging/rtl8723au//os_dep/os_intfs.c:287:14: error: Expected
> constant expression in case statement
> To avoid sparse parse error, a case statement converts to an if statement.
> So we got this patch.

Hello

I understand this part, but it seems to me we are changing the code due
to a broken test case in sparse. Does the warning go away if you use
__constant_htons() instead of htons()?

Jes
