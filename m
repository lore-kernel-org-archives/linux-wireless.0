Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcBAM3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:29:19 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Rakhi Sharma <rakhish1994@gmail.com>, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed space and brace coding style issue.
References: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com>
	<wrfjy4b5zuhl.fsf@redhat.com> <1454261145.7329.58.camel@perches.com>
Date: Mon, 01 Feb 2016 07:29:17 -0500
In-Reply-To: <1454261145.7329.58.camel@perches.com> (Joe Perches's message of
	"Sun, 31 Jan 2016 09:25:45 -0800")
Message-ID: <wrfjio287gwy.fsf@redhat.com> (sfid-20160201_132922_919007_FFA56145)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Sun, 2016-01-31 at 09:36 -0500, Jes Sorensen wrote:
>> Rakhi Sharma <rakhish1994@gmail.com> writes:
>> > Fixed the space and brace coding style error.
>> > ERROR: space required before that '='
>> > ERROR: that open brace { should be on the previous line.
>> > 
>> > Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
>> > ---
>> >  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> > b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> > index 3b0d782..0c933e4 100644
>> > --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> > +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
>> > @@ -65,8 +65,8 @@ static u8 WIFI_OFDMRATES[] = {
>> >  
>> >  int rtw_get_bit_value_from_ieee_value23a(u8 val)
>> >  {
>> > -	unsigned char dot11_rate_table[] =
>> > -			{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
>> > +	unsigned char dot11_rate_table[] = {
>> > +		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
>> >  
>> >  	int i = 0;
>> 
>> This is a great example of checkpatch doing the wrong thing. What you
>> did here was to make the code uglier rather than better.
>> 
>> NACK
>
> Here's the original code:
>
> int rtw_get_bit_value_from_ieee_value23a(u8 val)
> {
> 	unsigned char dot11_rate_table[]=
> 		{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
>
> 	int i = 0;
>
> 	while (dot11_rate_table[i] != 0) {
> 		if (dot11_rate_table[i] == val)
> 			return BIT(i);
> 		i++;
> 	}
> 	return 0;
> }
>
> It has several nominal style defects:
>
> o compares different types (unsigned char to u8)
> o uses a while loop and test of a known sized array
> o array isn't declared static const
> o array initialization is different style from others
>   in the same file. "type foo[] = { bar, baz };"
> o the function argument is tested on the right side
>   tested on left side is more common.
>
> So this could be transformed into something like:
>
> int rtw_get_bit_value_from_ieee_value23a(u8 val)
> {
> 	int i;
> 	static const u8 dot11_rate_table[] = {
> 		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
> 	};

and per my previous email, the above is worse than than the original.
The cleaner way to list it would be:

	static const char dot11_rate_table[] =
		{ 2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108 };

Jes
