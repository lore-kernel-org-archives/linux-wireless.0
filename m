Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45172 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1DFRRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 13:17:33 -0400
Received: by qwk3 with SMTP id 3so1008956qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 10:17:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104061423.02484.chunkeey@googlemail.com>
References: <BANLkTinLdpaS9GLN88ObSACbmQJOK7wnug@mail.gmail.com> <201104061423.02484.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Apr 2011 10:17:13 -0700
Message-ID: <BANLkTinaQHv-WUdg6F+xSE-X36bzOqCphQ@mail.gmail.com>
Subject: Re: invalid regdomain: 0x5c (was: problem with D-Link DWA-160)
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Joe Culler <joe.culler@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Green <michael.green@atheros.com>,
	David Quan <david.quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2011 at 5:23 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday 06 April 2011 05:26:28 Joe Culler wrote:
>> [...]
>> I have a problem with carl9170 driver with my d-link dwa-160 under
>> linux-2.6.39-rc1.
>> Here's the dmesg:
>
>> [ 3114.257063] ath: EEPROM regdomain: 0x5c
>> [ 3114.257066] ath: EEPROM indicates we should expect a direct regpair map
>> [ 3114.257069] ath: invalid regulatory domain/country code 0x5c
>> [ 3114.257071] ath: Invalid EEPROM contents
> clearly, the regdomain code 0x5c is not defined in the
> drivers/net/wireless/ath/regd_common.h => regDomainPairs struct.
>
> this would be easy to fix [see attached patch], however I'm
> not quite sure what to do about the 5GHz band in this case,
> since the CTL_FCC is more restrictive than it should be.
>
> Regards,
>        Chr
>
> ---
> diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
> index 248c670..5c2cfe6 100644
> --- a/drivers/net/wireless/ath/regd_common.h
> +++ b/drivers/net/wireless/ath/regd_common.h
> @@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
>        {APL9_WORLD, CTL_ETSI, CTL_ETSI},
>
>        {APL3_FCCA, CTL_FCC, CTL_FCC},
> +       {APL7_FCCA, CTL_FCC, CTL_FCC},
>        {APL1_ETSIC, CTL_FCC, CTL_ETSI},
>        {APL2_ETSIC, CTL_FCC, CTL_ETSI},
>        {APL2_APLD, CTL_FCC, NO_CTL},

I verified internally with our other code and this is correct, APL7
maps to FCC CTL and FCCA maps to FCC CTL as well. For an upstream
patch:

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
