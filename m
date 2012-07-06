Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36220 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2GFHox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 03:44:53 -0400
Received: by wgbdr13 with SMTP id dr13so9054921wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 00:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341557069.4462.4.camel@jlt3.sipsolutions.net>
References: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com>
	<1341498452.4455.44.camel@jlt3.sipsolutions.net>
	<CADnjpYuWL1DQabomZiGPajv9108p7DwNHyTWwaKn48vVhRbMDg@mail.gmail.com>
	<1341557069.4462.4.camel@jlt3.sipsolutions.net>
Date: Fri, 6 Jul 2012 09:44:52 +0200
Message-ID: <CADnjpYtsJe=Y_Sb=EwD_Xv-y-Hns4NBKCx1JON_hsbwQJH7+Uw@mail.gmail.com> (sfid-20120706_094515_274870_D70C09A5)
Subject: Re: SIOCSIFFLAGS: operation not supported error message when
 tryinging to bring up an interface in adhoc mode
From: Philippe Agostini <philippe.agostini@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Thank you for your feebacks. I solved my problem, it was coming from
my add_interface callback. I was looking for a problem at the wrong
place !

Best regards

Philippe

On Fri, Jul 6, 2012 at 8:44 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-07-05 at 16:44 +0200, Philippe Agostini wrote:
>
>> /* Supported channel */
>> static struct ieee80211_channel channels = {
>>       .band = IEEE80211_BAND_2GHZ,
>>       .center_freq = 2437,
>>       .hw_value = 0,
>>       .flags = 0,
>>       .max_antenna_gain = 3,
>>       .max_power = 20,
>>       .max_reg_power = 20,
>>       .beacon_found = FALSE,
>>       .orig_flags = 0,
>>       .orig_mag = 0,
>>       .orig_mpwr = 0,
>> };/* struct ieee80211_channel */
>
> FWIW, you don't need to set zero values explicitly, like beacon_found.
> "FALSE" also isn't valid in the kernel, it should be lower case?
>
>
>
>>       /* Configuration and hardware information for an 802.11 PHY */
>>       struct ieee80211_hw *hw = priv->hw;
>
> So you're using mac80211,
>
>>       /* Number of available hardware queues */
>>       hw->queues = IEEE80211P_NUM_TXQ;
>
> That constant seems a bit too generic, but we're just debugging your
> driver now. I just don't think you should use "ieee80211p" as your
> driver name/tag.
>
>>       //wiphy->signal_type = CFG80211p_SIGNAL_TYPE_NONE;
>
> that is set by mac80211
>
>>       //wiphy->cipher_suites = NULL;
>>       //wiphy->n_cipher_suites = 0;
>
> so is this unless you override it
>
>>       //wiphy->retry_short = 1;
>>       //wiphy->retry_long = 1;
>>       //wiphy->frag_threshold = -1;
>>       //wiphy->rts_threshold = -1;
>>       //wiphy_net_set(&hw->wiphy,NULL);
>
> Heh, no, don't set any of these
>
>>       //SET_IEEE80211_DEV(hw,NULL);
>
> That you should do
>
>>       //wiphy->wext = NULL;
>
> don't touch :)
>
>>       /* Describes the frequency bands a wiphy is able to operate in */
>>       for (i = 0;i<IEEE80211_NUM_BANDS;i++) {
>>               wiphy->bands[i] = NULL;
>>       }
>
> again, no need to 0-initialize anything, it just makes your code
> needlessly large
>
>
> Anyway, you've not shown the most important part, the driver ops that it
> registers with mac80211.
>
> johannes
>



-- 
P.
