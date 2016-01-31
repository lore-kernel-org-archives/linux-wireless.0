Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:48659 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757309AbcAaRZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 12:25:50 -0500
Message-ID: <1454261145.7329.58.camel@perches.com> (sfid-20160131_182623_060727_39F0F7CA)
Subject: Re: [PATCH 3/3] Staging: rtl8723au: core: rtw_ieee80211: Fixed
 space and brace coding style issue.
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Rakhi Sharma <rakhish1994@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Sun, 31 Jan 2016 09:25:45 -0800
In-Reply-To: <wrfjy4b5zuhl.fsf@redhat.com>
References: <1454246643-24049-1-git-send-email-rakhish1994@gmail.com>
	 <wrfjy4b5zuhl.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-01-31 at 09:36 -0500, Jes Sorensen wrote:
> Rakhi Sharma <rakhish1994@gmail.com> writes:
> > Fixed the space and brace coding style error.
> > ERROR: space required before that '='
> > ERROR: that open brace { should be on the previous line.
> > 
> > Signed-off-by: Rakhi Sharma <rakhish1994@gmail.com>
> > ---
> >  drivers/staging/rtl8723au/core/rtw_ieee80211.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> > index 3b0d782..0c933e4 100644
> > --- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> > +++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
> > @@ -65,8 +65,8 @@ static u8 WIFI_OFDMRATES[] = {
> >  
> >  int rtw_get_bit_value_from_ieee_value23a(u8 val)
> >  {
> > -	unsigned char dot11_rate_table[] =
> > -			{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
> > +	unsigned char dot11_rate_table[] = {
> > +		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};
> >  
> >  	int i = 0;
> 
> This is a great example of checkpatch doing the wrong thing. What you
> did here was to make the code uglier rather than better.
> 
> NACK

Here's the original code:

int rtw_get_bit_value_from_ieee_value23a(u8 val)
{
	unsigned char dot11_rate_table[]=
		{2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108, 0};

	int i = 0;

	while (dot11_rate_table[i] != 0) {
		if (dot11_rate_table[i] == val)
			return BIT(i);
		i++;
	}
	return 0;
}

It has several nominal style defects:

o compares different types (unsigned char to u8)
o uses a while loop and test of a known sized array
o array isn't declared static const
o array initialization is different style from others
  in the same file. "type foo[] = { bar, baz };"
o the function argument is tested on the right side
  tested on left side is more common.

So this could be transformed into something like:

int rtw_get_bit_value_from_ieee_value23a(u8 val)
{
	int i;
	static const u8 dot11_rate_table[] = {
		2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
	};

	for (i = 0; i < ARRAY_SIZE(dot11_rate_table); i++) {
		if (val == dot11_rate_table[i])
			return BIT(i);
	}

	return 0;
}

Rakhi, do please strive to make the code "better" rather
than merely shut up checkpatch.

