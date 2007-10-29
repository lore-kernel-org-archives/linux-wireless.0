Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:38831 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756898AbXJ2UhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 16:37:09 -0400
Message-ID: <4726433A.2070808@linux.intel.com> (sfid-20071029_203715_152240_893D0872)
Date: Mon, 29 Oct 2007 13:31:54 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: dragoran <drago01@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [ipw3945-devel] iwl3945 lists supported rates backwards
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>	<20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>	<4719BA96.3010609@gmail.com> <1193644281.27622.12.camel@dv>	<1193667153.5197.48.camel@johannes.berg> <1193677095.11181.2.camel@dv>	<1193677748.5197.77.camel@johannes.berg> <f6ca9fed0710291153o68ec2cffqbd2cc3f6d57fa11b@mail.gmail.com>
In-Reply-To: <f6ca9fed0710291153o68ec2cffqbd2cc3f6d57fa11b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This might break rate scaling for 3945 adapter. I look into rearrange 
the rate and do what ever needed to make rate scaling wont break.
Mohamed
dragoran wrote:
> On 10/29/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>   
>>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>>> @@ -5414,10 +5414,10 @@ static int iwl_init_geos(struct iwl_priv *priv)
>>>        * is supported by a mode -- and the first match is taken
>>>        */
>>>
>>> -     if (modes[G].num_channels)
>>> -             ieee80211_register_hwmode(priv->hw, &modes[G]);
>>>       if (modes[B].num_channels)
>>>               ieee80211_register_hwmode(priv->hw, &modes[B]);
>>> +     if (modes[G].num_channels)
>>> +             ieee80211_register_hwmode(priv->hw, &modes[G]);
>>>       if (modes[A].num_channels)
>>>               ieee80211_register_hwmode(priv->hw, &modes[A]);
>>>       
>> Huh no, you misunderstood my mail.
>>
>> This makes mac80211 always select 802.11B mode which is not what you
>> want. You want to change the order of rates within the G mode.
>>
>>     
>
> shouldn't this one do it?
>  (untested)
>
> ---
> diff --git a/origin/iwl-3945-rs.h b/origin/iwl-3945-rs.h
> index 09fa1a7..18b19a2 100644
> --- a/origin/iwl-3945-rs.h
> +++ b/origin/iwl-3945-rs.h
> @@ -39,7 +39,11 @@ struct iwl_rate_info {
>  };
>
>  enum {
> -       IWL_RATE_6M_INDEX = 0,
> +       IWL_RATE_1M_INDEX = 0,
> +       IWL_RATE_2M_INDEX,
> +       IWL_RATE_5M_INDEX,
> +       IWL_RATE_11M_INDEX,
> +       IWL_RATE_6M_INDEX,
>         IWL_RATE_9M_INDEX,
>         IWL_RATE_12M_INDEX,
>         IWL_RATE_18M_INDEX,
> @@ -47,10 +51,6 @@ enum {
>         IWL_RATE_36M_INDEX,
>         IWL_RATE_48M_INDEX,
>         IWL_RATE_54M_INDEX,
> -       IWL_RATE_1M_INDEX,
> -       IWL_RATE_2M_INDEX,
> -       IWL_RATE_5M_INDEX,
> -       IWL_RATE_11M_INDEX,
>         IWL_RATE_COUNT,
>         IWL_RATE_INVM_INDEX,
>         IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>   
