Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab2EaCX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 22:23:57 -0400
Received: by lbbgm6 with SMTP id gm6so493976lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 19:23:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338430181-12490-1-git-send-email-yeohchunyeow@gmail.com>
References: <1338430181-12490-1-git-send-email-yeohchunyeow@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 31 May 2012 12:23:34 +1000
Message-ID: <CAGRGNgWXF5AMQfSkoCBGWgB1sod6fOEqViDiFCif2hqLx55N0g@mail.gmail.com> (sfid-20120531_042419_616214_239AC8E5)
Subject: Re: [PATCH] {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Thu, May 31, 2012 at 12:09 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> As defined in section 13.10.9.3 Case D (802.11-2012), this control variable is used to limit the
> mesh STA to send only one PREQ to a root mesh STA within this interval of time (in TUs). The
> default value for this variable is set to 2000 TUs. However, for current implementation, the maximum
> configurable of dot11MeshHWMPconfirmationInterval is restricted by dot11MeshHWMPactivePathTimeout.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a6959f7..14bbf47 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -2136,6 +2136,10 @@ enum nl80211_mntr_flags {
>  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
>  * root announcements are transmitted.
>  *
> + * @NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL: The minimum interval of time
> + * (in TUs) during which a mesh STA can send only one Action frame containing
> + * a PREQ element for root path confirmation.

This doesn't make sense.

Is this what you're trying to say?

"Minimum interval of time (in TUs) between sending Action frames
containing PREQ elements for root path confirmation."

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
