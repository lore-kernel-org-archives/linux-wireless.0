Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [220.194.60.87] ([220.194.60.87]:57164 "EHLO
	mail.redflag-linux.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbcHKWug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 18:50:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is variable issue
From: sunbing <sunbing@redflag-linux.com>
In-Reply-To: <wrfja8gje395.fsf@redhat.com>
Date: Fri, 12 Aug 2016 06:50:03 +0800
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com
Message-Id: <7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com> (sfid-20160812_005055_213136_C3C34F4E)
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com> <wrfja8gje395.fsf@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Aug 11, 2016, at 23:25, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> Bing Sun <sunbing@redflag-linux.com> writes:
>> Fixed sparse parse error:
>> Expected constant expression in case statement.
>> 
>> Signed-off-by: Bing Sun <sunbing@redflag-linux.com>
>> ---
>> drivers/staging/rtl8723au/os_dep/os_intfs.c | 11 +++++------
>> 1 file changed, 5 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
>> index b8848c2..f30d5d2 100644
>> --- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
>> +++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
>> @@ -283,14 +283,13 @@ static u32 rtw_classify8021d(struct sk_buff *skb)
>> 	 */
>> 	if (skb->priority >= 256 && skb->priority <= 263)
>> 		return skb->priority - 256;
>> -	switch (skb->protocol) {
>> -	case htons(ETH_P_IP):
>> +
>> +	if (skb->protocol == htons(ETH_P_IP)) {
>> 		dscp = ip_hdr(skb)->tos & 0xfc;
>> -		break;
>> -	default:
>> -		return 0;
>> +		return dscp >> 5;
>> 	}
>> -	return dscp >> 5;
>> +
>> +	return 0;
>> }
> 
> Pardon me here, but I find it really hard to see how this change is an
> improvement over the old code in any shape or form.
> 
> Jes


There is no functional improvement. 
But before this patch, when we do: make C=1 M=drivers/staging/rtl8723au/
An error output: 
drivers/staging/rtl8723au//os_dep/os_intfs.c:287:14: error: Expected constant expression in case statement
To avoid sparse parse error, a case statement converts to an if statement.
So we got this patch.



