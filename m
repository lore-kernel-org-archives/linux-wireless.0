Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40108 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3HOQHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 12:07:19 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so998833pdj.32
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 09:07:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376568235.14084.12.camel@jlt4.sipsolutions.net>
References: <1376395438-24788-1-git-send-email-arik@wizery.com> <1376568235.14084.12.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 15 Aug 2013 19:07:03 +0300
Message-ID: <CA+XVXffREZsiLU_Gs646-akyW9XNcZEmQnQGsp4ihT92hP7LOw@mail.gmail.com> (sfid-20130815_180723_198260_7CF038EA)
Subject: Re: [PATCH] mac80211: implement STA CSA for drivers using channel contexts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 15, 2013 at 3:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> @@ -2872,6 +2872,11 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>>       if (WARN_ON(err < 0))
>>               return;
>>
>> +     if (!local->use_chanctx) {
>> +             local->_oper_chandef = local->csa_chandef;
>> +             ieee80211_hw_config(local, 0);
>> +     }
>
> I don't really understand this part - I think you should add some
> documentation or something?

Basically I removed this chunk of code from
ieee80211_vif_change_channel() and put it here - a bit later in the AP
CSA flow.
I don't think it does any harm.

>
>> @@ -453,11 +453,6 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
>>       chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
>>       drv_change_chanctx(local, ctx, chanctx_changed);
>>
>> -     if (!local->use_chanctx) {
>> -             local->_oper_chandef = *chandef;
>> -             ieee80211_hw_config(local, 0);
>> -     }
>
> I really don't like it either - this was here so that no other code
> really needed to be worried about non-chanctx drivers.

Well right now ieee80211_chswitch_work() takes care of it, and does
something a bit different there to accommodate the legacy behavior -
if the chan_switch op is defined, ieee80211_hw_config is not called.
Would you prefer that ieee80211_vif_change_channel() handle all this,
checking interface type to do the right thing?

>
>> @@ -1180,17 +1196,27 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
>>       }
>>
>>       ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
>> +     sdata->vif.csa_active = true;
>
> I don't think we can just do this - this isn't going to result in good
> behaviour for multi-vif drivers and in particular I'm pretty sure with
> the MVM driver this would result in bad behaviour.
>
> If you really want to do this I think it needs to be optional.

I only added it since the current implementation of
ieee80211_vif_change_channel() bails if it's false. That said, I'm not
sure what's wrong here. This setting is per-vif.

>
> Also the documentation for the chanctx channel change probably needs to
> be updated, etc.

Is there any current documentation? The AP CSA patches by Simon didn't
have any IIRC.
I guess I'm not sure what's special here, we just replace the chandef
and that's it.

Arik
