Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:47999 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506AbbCNVzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 17:55:09 -0400
Message-ID: <1426370106.6696.16.camel@perches.com> (sfid-20150314_225514_413560_F05FE5EE)
Subject: Re: [PATCH 14/16] staging: rtl8723au: Improve readability of two
 very long lines
From: Joe Perches <joe@perches.com>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Sat, 14 Mar 2015 14:55:06 -0700
In-Reply-To: <55049722.9090702@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
	 <1426216532-24058-15-git-send-email-m.v.b@runbox.com>
	 <550305D5.9080209@lwfinger.net> <1426263881.11459.17.camel@perches.com>
	 <55049722.9090702@runbox.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-03-14 at 16:16 -0400, M. Vefa Bicakci wrote:
> On 13/03/15 12:24 PM, Joe Perches wrote:
> > On Fri, 2015-03-13 at 10:44 -0500, Larry Finger wrote:
> >> On 03/12/2015 10:15 PM, M. Vefa Bicakci wrote:
> >>> Improve the readability of an if statement and its very long trace
> >>> output line in rtl8723au's rtw_security.c.
> > []
> >>> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> > []
> >>> @@ -759,9 +759,21 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
> >>>
> >>>   	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
> >>>
> >>> -	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
> >>> -		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
> >>> -				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
> >>> +	if (crc[3] != payload[length - 1] ||
> >>> +			crc[2] != payload[length - 2] ||
> >>> +			crc[1] != payload[length - 3] ||
> >>> +			crc[0] != payload[length - 4]) {
> >>
> >> The continuation lines should be lined up with the opening paren. This should be
> >>
> >> 	if (crc[3] != payload[length - 1] ||
> >> 	    crc[2] != payload[length - 2] ||
> >> 	    crc[1] != payload[length - 3] ||
> >> 	    crc[0] != payload[length - 4]) {
> > 
> > Maybe:
> > 	if (memcmp(&crc, &payload[length - 4], 4)) {
> > 		RT_TRACE(etc, "%08x vs %4phN",
> > 			 crc, &payload[length - 4])
[]
> I have addressed your comments in my local repository, and I hope to send out
> the second version of the commits for review by tomorrow.

Maybe it'd be more sensible to use something like:

	u32 crc, orig_crc;

	[...]

	crc = le32_to_cpu(getcrc32(payload, length - 4));
	orig_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));

	if (crc != orig_crc) {
		RT_TRACE(etc, "bad crc: %08x vs %08x", crc, orig_crc);


