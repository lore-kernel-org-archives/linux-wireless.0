Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45858 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab0GTSXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:23:40 -0400
Received: by pvc7 with SMTP id 7so2262358pvc.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 11:23:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279220807-18245-1-git-send-email-linville@tuxdriver.com>
References: <1279220807-18245-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 20 Jul 2010 11:23:19 -0700
Message-ID: <AANLkTinPnjtbDM8AE7gKMA9lBnIJDqG-KXc04ynZ6wLg@mail.gmail.com>
Subject: Re: [RFC] wireless: only use alpha2 regulatory information from
	country IE
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, kyle@parisc-linux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 15, 2010 at 12:06 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> The meaning and/or usage of the country IE is somewhat poorly defined.
> In practice, this means that regulatory rulesets in a country IE are
> often incomplete and might be untrustworthy.  This removes the code
> associated with interpreting those rulesets while preserving respect
> for country "alpha2" codes also contained in the country IE.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

> @@ -2026,13 +1501,17 @@ static bool reg_same_country_ie_hint(struct wiphy *wiphy,
>                return false;
>
>        if (likely(request_wiphy != wiphy))
> -               return !country_ie_integrity_changes(country_ie_checksum);
> +               return (last_request->alpha2[0] == alpha2[0] &&
> +                       last_request->alpha2[1] == alpha2[1] &&
> +                       last_request->country_ie_env == env);
>        /*
>         * We should not have let these through at this point, they
>         * should have been picked up earlier by the first alpha2 check
>         * on the device
>         */
> -       if (WARN_ON(!country_ie_integrity_changes(country_ie_checksum)))
> +       if (WARN_ON((last_request->alpha2[0] == alpha2[0] &&
> +                       last_request->alpha2[1] == alpha2[1] &&
> +                       last_request->country_ie_env == env )))
>                return true;
>        return false;
>  }

Might as well remove  reg_same_country_ie_hint() completely since we
already dealt with suspend/resume through the regulatory hint
disconnect. But this can technically be done through a secondary patch
to clarify this particular removal. Other than that this looks good.

  Luis
