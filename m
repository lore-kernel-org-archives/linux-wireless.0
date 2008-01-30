Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYA3EFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 23:05:22 -0500
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200710151255.56358.hs4233@mail.mn-solutions.de>
References: <200710151255.56358.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 15:05:12 +1100
Message-Id: <1201665912.28377.38.camel@shinybook.infradead.org> (sfid-20080130_040526_673602_7CAFCC84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-15 at 12:55 +0200, Holger Schurig wrote:
> @@ -435,40 +415,51 @@ static int assoc_helper_wpa_ie(lbs_priva
>  static int should_deauth_infrastructure(lbs_adapter *adapter,
>                                          struct assoc_request * assoc_req)
>  {
> +       int ret = 0;
> +
> +       lbs_deb_enter(LBS_DEB_ASSOC);
> +
>         if (adapter->connect_status != LBS_CONNECTED)
>                 return 0;
>  
>         if (test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
> -               lbs_deb_assoc("Deauthenticating due to new SSID in "
> -                       " configuration request.\n");
> -               return 1;
> +               lbs_deb_assoc("Deauthenticating due to new SSID\n");
> +               ret = 1;
> +               goto out;
>         }
>  
>         if (test_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags)) {
>                 if (adapter->secinfo.auth_mode != assoc_req->secinfo.auth_mode) {
> -                       lbs_deb_assoc("Deauthenticating due to updated security "
> -                               "info in configuration request.\n");
> -                       return 1;
> +                       lbs_deb_assoc("Deauthenticating due to new security\n");
> +                       ret = 1;
> +                       goto out;
>                 }
>         }
>  
>         if (test_bit(ASSOC_FLAG_BSSID, &assoc_req->flags)) {
> -               lbs_deb_assoc("Deauthenticating due to new BSSID in "
> -                       " configuration request.\n");
> -               return 1;
> +               lbs_deb_assoc("Deauthenticating due to new BSSID\n");
> +               ret = 1;
> +               goto out;
>         }
>  
>         if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
> -               lbs_deb_assoc("Deauthenticating due to channel switch.\n");
> -               return 1;
> +               lbs_deb_assoc("Deauthenticating due to channel switch\n");
> +               ret = 1;
> +               goto out;
>         }
>  
>         /* FIXME: deal with 'auto' mode somehow */
>         if (test_bit(ASSOC_FLAG_MODE, &assoc_req->flags)) {
> -               if (assoc_req->mode != IW_MODE_INFRA)
> -                       return 1;
> +               if (assoc_req->mode != IW_MODE_INFRA) {
> +                       lbs_deb_assoc("Deauthenticating due to leaving "
> +                               "infra mode\n");
> +                       ret = 1;
> +                       goto out;
> +               }
>         }
>  
> +out:
> +       lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
>         return 0;

Oops. That should be changed to 'return ret', and caused OLPC trac
#5485.

Please, make sure you pay _lots_ of attention when doing cleanups,
especially where the code is of such low quality in the first place.

I'm still working through cleanups in the driver; I see you're sending
changes directly upstream. Since upstream doesn't use git normally, I
suspect that's going to cause lots of pain when it comes to merging. Any
chance we could stick to the libertas-2.6.git tree? Cleanups I can do
easily when I'm stuck in tin cans and push to the development tree as
soon as I land -- but I don't want to send them upstream until they've
had a little more testing.

-- 
dwmw2

